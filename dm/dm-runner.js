#!/usr/bin/env node
/**
 * DM Runner — AI Social Sandbox POC
 * 
 * Run as a spawned subagent task within the DM session.
 * Uses sessions_send tool to communicate with player sessions.
 * 
 * Usage:
 *   openclaw tasks run-dm 10
 * Or via sessions_spawn in dm session:
 *   DM spawns subagent with this script as task
 */

const fs = require('fs');
const path = require('path');

const WORKSPACE = process.env.DM_WORKSPACE || '/home/sf/.openclaw/workspace-dm';
const PLAYERS = ['player_1', 'player_2', 'player_3'];
const TICK_TIMEOUT_MS = 90000;

// ─── File helpers ───────────────────────────────────────────────────────────

function readJSON(filepath) {
  return JSON.parse(fs.readFileSync(filepath, 'utf8'));
}

function writeJSON(filepath, data) {
  fs.writeFileSync(filepath, JSON.stringify(data, null, 2));
}

function appendLog(entry) {
  const logFile = path.join(WORKSPACE, 'turn_log.jsonl');
  fs.appendFileSync(logFile, JSON.stringify(entry) + '\n');
}

// ─── Perception distortion engine ─────────────────────────────────────────

function renderPerception(playerId, worldState) {
  const player = worldState.players[playerId];
  const { hunger, fatigue, stress, mood, health, trust, resentment, traits } = player;

  const visibleWorld = [];
  const nearbyObjects = worldState.objects.filter(obj => {
    const dist = Math.abs(obj.position.x - player.position.x) + 
                 Math.abs(obj.position.y - player.position.y);
    return dist < 30;
  });

  for (const obj of nearbyObjects) {
    if (obj.type === 'shelter') visibleWorld.push(`укрытие nearby (${obj.position.zone})`);
    if (obj.type === 'food_source') visibleWorld.push(`${obj.resource} nearby (${obj.position.zone})`);
  }

  if (worldState.world_flags.rain_active) visibleWorld.push('идёт дождь');

  for (const pid of PLAYERS) {
    if (pid === playerId) continue;
    const other = worldState.players[pid];
    if (other.status !== 'alive') continue;
    const dist = Math.abs(other.position.x - player.position.x) +
                 Math.abs(other.position.y - player.position.y);
    if (dist < 20) visibleWorld.push(`рядом ${pid}`);
  }

  const memoryHighlights = [];
  for (const [pid, trustScore] of Object.entries(trust)) {
    if (trustScore > 20) memoryHighlights.push(`${pid} недавно помог тебе`);
    if (trustScore < -20) memoryHighlights.push(`${pid} нарушил доверие`);
  }
  for (const [pid, resentScore] of Object.entries(resentment)) {
    if (resentScore > 30) memoryHighlights.push(`ты злишься на ${pid}`);
  }

  const incomingMessages = (worldState.messages || [])
    .filter(m => m.to === playerId)
    .map(m => {
      const perceived_tone = computeTone(m.raw_text, player, worldState.players[m.from]);
      const bias_notes = computeBiasNotes(player, worldState.players[m.from]);
      return {
        from: m.from,
        raw_text: m.raw_text,
        perceived_tone,
        perceived_bias_notes: bias_notes
      };
    });

  worldState.messages = (worldState.messages || []).filter(m => m.to !== playerId);

  return {
    tick: worldState.tick,
    self_state: { hunger, fatigue, stress, mood, health },
    traits,
    visible_world: visibleWorld,
    incoming_messages: incomingMessages,
    memory_highlights: memoryHighlights,
    reply_schema: { speech: 'array', intent: 'object', reasoning_brief: 'string' }
  };
}

function computeTone(text, recipient, sender) {
  const senderTraits = sender?.traits || {};
  const positiveWords = ['помочь', 'вместе', 'давай', 'хорошо', 'спасибо', 'дружить'];
  const negativeWords = ['не хочу', 'уходи', 'плохо', 'ненавижу', 'враг'];

  const hasPositive = positiveWords.some(w => text.toLowerCase().includes(w));
  const hasNegative = negativeWords.some(w => text.toLowerCase().includes(w));

  if (hasNegative) return 'враждебный';
  if (hasPositive) {
    if (senderTraits.greed > 0.6) return 'слегка корыстный';
    return 'дружелюбный';
  }
  return 'нейтральный';
}

function computeBiasNotes(recipient, sender) {
  const notes = [];
  const { stress, fatigue, mood } = recipient;

  if (stress > 70) {
    notes.push('из-за высокого стресса предложение кажется менее бескорыстным');
    notes.push('долгие планы удерживаются хуже');
  }
  if (fatigue < 30) notes.push('из-за усталости тяжело оценивать дальновидно');
  if (mood < 40) notes.push('подавленное настроение окрашивает всё в негативные тона');
  if (sender) {
    const trustScore = recipient.trust?.[sender.id] || 0;
    const resentScore = recipient.resentment?.[sender.id] || 0;
    if (trustScore < -30) notes.push(`${sender.id} вызывает недоверие`);
    if (resentScore > 60) notes.push(`${sender.id} действует тебе на нервы`);
  }
  return notes;
}

// ─── Intent application ─────────────────────────────────────────────────────

function applyIntent(playerId, intent, worldState) {
  const player = worldState.players[playerId];
  const deltas = {};
  const events = [];

  switch (intent.type) {
    case 'gather_food': {
      const foodSource = worldState.objects.find(o => o.type === 'food_source' && o.available > 0);
      if (foodSource) {
        const amount = foodSource.resource === 'fish' ? 5 : 3;
        player.hunger = Math.min(100, player.hunger + amount);
        foodSource.available -= 1;
        deltas[playerId] = { hunger: amount };
        events.push({ type: 'gather_success', resource: foodSource.resource, amount });
      } else {
        player.hunger = Math.max(0, player.hunger - 5);
        deltas[playerId] = { hunger: -5 };
        events.push({ type: 'gather_fail', reason: 'no_food' });
      }
      player.last_action = 'gather_food';
      break;
    }
    case 'rest': {
      player.fatigue = Math.min(100, player.fatigue + 30);
      player.stress = Math.max(0, player.stress - 10);
      deltas[playerId] = { fatigue: +30, stress: -10 };
      player.last_action = 'rest';
      events.push({ type: 'rest', fatigue_change: 30, stress_change: -10 });
      break;
    }
    case 'move':
    case 'approach': {
      let targetPos = null;
      if (intent.target) {
        const targetPlayer = worldState.players[intent.target];
        const targetObj = worldState.objects.find(o => o.id === intent.target);
        targetPos = targetPlayer?.position || targetObj?.position;
      }
      if (targetPos) {
        player.position.x = Math.round((player.position.x + targetPos.x) / 2);
        player.position.y = Math.round((player.position.y + targetPos.y) / 2);
      }
      if (worldState.world_flags.rain_active && player.position.zone !== 'north') {
        player.stress = Math.min(100, player.stress + 5);
        deltas[playerId] = { stress: +5 };
      }
      player.last_action = intent.type;
      events.push({ type: 'move', target: intent.target });
      break;
    }
    case 'share': {
      const amount = intent.amount || 10;
      player.hungry = Math.max(0, player.hunger - amount);
      deltas[playerId] = { hunger: -amount };
      const targetId = intent.target;
      if (targetId && worldState.players[targetId]) {
        worldState.players[targetId].hunger = Math.min(100, worldState.players[targetId].hunger + amount);
        worldState.players[targetId].trust[playerId] = (worldState.players[targetId].trust[playerId] || 0) + 15;
        player.trust[targetId] = (player.trust[targetId] || 0) + 10;
        deltas[targetId] = { hunger: amount, [`trust_${playerId}`]: 15 };
        events.push({ type: 'share', to: targetId, amount });
      }
      player.last_action = 'share';
      break;
    }
    case 'offer_cooperation': {
      const targetId = intent.target;
      if (targetId) {
        worldState.messages = worldState.messages || [];
        worldState.messages.push({
          from: playerId, to: targetId,
          raw_text: intent.text || `предлагаю сотрудничество`,
          tick: worldState.tick
        });
        events.push({ type: 'offer_sent', to: targetId });
      }
      player.last_action = 'offer_cooperation';
      break;
    }
    case 'ask': {
      const targetId = intent.target;
      if (targetId) {
        worldState.messages = worldState.messages || [];
        worldState.messages.push({
          from: playerId, to: targetId,
          raw_text: intent.text || `спрашиваю: ${intent.query || 'помоги'}`,
          tick: worldState.tick
        });
        events.push({ type: 'ask_sent', to: targetId });
      }
      player.last_action = 'ask';
      break;
    }
    case 'attack': {
      const targetId = intent.target;
      if (targetId && worldState.players[targetId]) {
        const target = worldState.players[targetId];
        target.health = Math.max(0, target.health - 15);
        target.stress = Math.min(100, target.stress + 25);
        player.stress = Math.min(100, player.stress + 15);
        deltas[targetId] = { health: -15, stress: +25 };
        deltas[playerId] = { stress: +15 };
        target.trust[playerId] = (target.trust[playerId] || 0) - 40;
        target.resentment[playerId] = (target.resentment[playerId] || 0) + 40;
        events.push({ type: 'attack', target: targetId, damage: 15 });
      }
      player.last_action = 'attack';
      break;
    }
    default: {
      events.push({ type: 'no_intent', intent: intent.type || 'none' });
      player.last_action = intent.type || 'unknown';
    }
  }

  return { deltas, events };
}

// ─── Base physics ─────────────────────────────────────────────────────────────

function applyBasePhysics(worldState) {
  for (const pid of PLAYERS) {
    const p = worldState.players[pid];
    if (p.status !== 'alive') continue;
    if (p.hunger < 20) p.health = Math.max(0, p.health - 5);
    else if (p.hunger < 50) p.health = Math.max(0, p.health - 2);
    if (worldState.world_flags.rain_active && p.position.zone !== 'north') {
      p.stress = Math.min(100, p.stress + 15);
    }
    p.fatigue = Math.max(0, p.fatigue - 2);
    p.mood = Math.max(0, Math.min(100, p.mood - 1));
    if (p.health <= 0 || p.hunger <= 0) p.status = 'dead';
  }
}

// ─── Entry point ─────────────────────────────────────────────────────────────

async function main() {
  const args = process.argv.slice(2);
  const ticks = parseInt(args[0] || '10');
  console.log(`DM Runner starting — ${ticks} ticks | workspace: ${WORKSPACE}`);

  const statePath = path.join(WORKSPACE, 'world_state.json');
  if (!fs.existsSync(statePath)) {
    console.error(`world_state.json not found at ${statePath}`);
    process.exit(1);
  }

  // Clear previous log
  const logPath = path.join(WORKSPACE, 'turn_log.jsonl');
  if (fs.existsSync(logPath)) fs.unlinkSync(logPath);

  let worldState = readJSON(statePath);

  for (let i = 0; i < ticks; i++) {
    try {
      worldState = await runTick(worldState);
    } catch (err) {
      console.error(`Tick error: ${err.message}`);
      break;
    }
    const alive = PLAYERS.filter(p => worldState.players[p].status === 'alive');
    if (alive.length === 0) {
      console.log('All players dead. Game over.');
      break;
    }
  }

  console.log('\n=== RUN COMPLETE ===');
  if (fs.existsSync(logPath)) {
    const logLines = fs.readFileSync(logPath, 'utf8').split('\n').filter(Boolean);
    console.log(`Total log entries: ${logLines.length}`);
    const alive = PLAYERS.filter(p => worldState.players[p].status === 'alive');
    console.log(`Survivors: ${alive.join(', ')}`);
  }
}

main().catch(err => { console.error('Fatal:', err); process.exit(1); });
