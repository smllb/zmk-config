# Changelog

## Tupa (62-pos split)

### 2025-07-06
- Fix: remove 4 conflicting combo pairs (ground_self/split_mode, tab_mode/caps_split, copy_all_tab/toggle_tile, grab_tile/copy_terminal)
- Fix: question_send macro — remove broken `&macro_tap` from bindings
- Update: hml_gui hold-trigger-key-positions changed from 56-59 (SPACE,DOWN,UP,LEFT) to 57-60 (DOWN,UP,LEFT,RIGHT)
- Add: tab_mode and split_mode combos (LG(W) and LG(E))

### 2025-07-05
- Rename BT device name: Tupa → siraya
- Shift right side row 4 keys right by 1 position
- Fix info.json: right side x-offsets aligned vertically

### 2025-07-04
- Tupa 62-position layout: expanded thumb row, row2col diode
- Fix 32 combo positions after row 2 remap correction
- Fix row 2: left lone key → SPACE, right lone key → ESC
- Fix diode-direction: col2row → row2col to match handwired board
- Build script for container paths, tupa shield
- Migrate aysu consolidated keymap to tupa: 56→62 position remap, all layers/combos
- Add tupa split keyboard: combined 5x14 matrix, left central + right peripheral
