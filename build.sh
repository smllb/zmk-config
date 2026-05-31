#!/bin/bash
set -euo pipefail

BOARD="${BOARD:-nice_nano_v2}"
SHIELD="aysu"
CONFIG_PATH="$(cd "$(dirname "$0")/config" && pwd)"
RESULTS_DIR="/workspaces/firmware"
TIMESTAMP="$(date +%s)"
OUTPUT_DIR="$RESULTS_DIR/run-$TIMESTAMP"
ZMK_APP="${ZMK_APP:-/workspaces/zmk/app}"

cd "$ZMK_APP" || { echo "ERROR: $ZMK_APP not found"; exit 1; }

echo "=========================================="
echo "Build Run: $TIMESTAMP"
echo "Output:     $OUTPUT_DIR"
echo "Board:      $BOARD"
echo "Shield:     $SHIELD"
echo "Config:     $CONFIG_PATH"
echo "=========================================="

mkdir -p "$OUTPUT_DIR"

build_side() {
    local side="$1" label="$2"
    echo "--> Building $label..."
    west build -p -b "$BOARD" -- \
        -DSHIELD="${SHIELD}_${side}" \
        -DZMK_CONFIG="$CONFIG_PATH" \
        -DBOARD_ROOT="$CONFIG_PATH"
    cp build/zephyr/zmk.uf2 "$OUTPUT_DIR/${SHIELD}_${side}.uf2"
    echo "OK $label built"
}

build_side "left"  "LEFT"
build_side "right" "RIGHT"

echo "--> Building RESET firmware..."
west build -p -b "$BOARD" -- -DSHIELD=settings_reset
cp build/zephyr/zmk.uf2 "$OUTPUT_DIR/settings_reset.uf2"
echo "OK Reset firmware built"

echo "=========================================="
echo "Done: $OUTPUT_DIR"
ls -lh "$OUTPUT_DIR/"
echo "=========================================="
