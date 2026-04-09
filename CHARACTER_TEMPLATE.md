# CHARACTER_TEMPLATE.md

Use this file when creating a new character folder for `campaign/cast/<character_id>/`.

## Creation sources

A new character may be created from either:
1. a source template in `players/<template_id>/`
2. an already finished / reviewed character folder from another campaign or run

In both cases the target structure is the same.

## Target structure

```text
campaign/cast/<character_id>/
  soul.md
  current_state.json
  relations.json
  memory_imprints.json
  continuity_notes.md
```

## How to create from `players/`

1. Choose the source template folder.
2. Copy the whole folder into `campaign/cast/<character_id>/`.
3. Rename and adapt the contents for the new concrete character.
4. Update state, relations, memory, and continuity for the current campaign.

## How to create from an existing finished character

1. Copy the reviewed character folder into `campaign/cast/<character_id>/`.
2. Keep what is truly part of the person.
3. Reset or adapt campaign-specific state, relations, memory, and continuity.
4. Make sure the folder matches the current campaign, not the old one.

## File expectations

### `soul.md`
Who this person is, how they tend to perceive, cope, distort, seek, avoid, and react under pressure.

### `current_state.json`
Only the active state parameters used by the current campaign.

### `relations.json`
Per-other-character relation fields used by the current campaign.
Typical fields: `trust`, `resentment`, `affinity`.

### `memory_imprints.json`
Current memory imprints relevant to this person.
Follow `docs/MEMORY_MODEL.md`.

### `continuity_notes.md`
Short human-readable continuity summary for Lab DM / Run DM handoff.
