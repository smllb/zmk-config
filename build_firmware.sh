#!/bin/bash

# --- CONFIGURATION ---
BOARD="nice_nano@2"
CONFIG_PATH="/workspaces/zmk-config/config"
RESULTS_DIR="/workspaces/firmware"
TIMESTAMP=$(date +%s)
OUTPUT_DIR="$RESULTS_DIR/run-$TIMESTAMP"

# Ensure we are in the ZMK App directory
cd /workspaces/zmk/app || { echo "ERROR: Could not find /workspaces/zmk/app"; exit 1; }

# --- SETUP ---
echo "=========================================="/.
echo "Starting Build Run: $TIMESTAMP"
echo "Output Directory: $OUTPUT_DIR"
echo "=========================================="

# Create the results directories
mkdir -p "$OUTPUT_DIR"

# Ensure specific left/right keymaps exist (copy from main)
echo "--> Preparing keymap files..."
cp "$CONFIG_PATH/aysu.keymap" "$CONFIG_PATH/aysu_left.keymap"
cp "$CONFIG_PATH/aysu.keymap" "$CONFIG_PATH/aysu_right.keymap"

# --- BUILD LEFT ---
echo "--> Building LEFT side..."
west build -p -b $BOARD -- -DSHIELD=aysu_left -DZMK_CONFIG="$CONFIG_PATH" -DBOARD_ROOT="$CONFIG_PATH"

if [ $? -eq 0 ]; then
    cp build/zephyr/zmk.uf2 "$OUTPUT_DIR/aysu_left.uf2"
    echo "✅ Left side built successfully."
else
    echo "❌ Left side FAILED. Check console for errors."
    exit 1
fi

# --- BUILD RIGHT ---
echo "--> Building RIGHT side..."
west build -p -b $BOARD -- -DSHIELD=aysu_right -DZMK_CONFIG="$CONFIG_PATH" -DBOARD_ROOT="$CONFIG_PATH" > /dev/null 2>&1

if [ $? -eq 0 ]; then
    cp build/zephyr/zmk.uf2 "$OUTPUT_DIR/aysu_right.uf2"
    echo "✅ Right side built successfully."
else
    echo "❌ Right side FAILED."
    exit 1
fi

# --- BUILD RESET ---
echo "--> Building RESET firmware..."
west build -p -b $BOARD -- -DSHIELD=settings_reset > /dev/null 2>&1

if [ $? -eq 0 ]; then
    cp build/zephyr/zmk.uf2 "$OUTPUT_DIR/settings_reset.uf2"
    echo "✅ Reset firmware built successfully."
else
    echo "❌ Reset firmware FAILED."
fi

echo "=========================================="
echo "All done! Files are located in:"
echo "$OUTPUT_DIR"
echo "=========================================="
