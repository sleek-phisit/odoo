#!/bin/bash
# %-Sz&4+5ICm78Wa_

# Odoo Local Startup Script for macOS
# -----------------------------------

# Get the absolute path of the directory where this script is located
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd "$ROOT_DIR"

# 1. Virtual Environment Detection
# Checks for common venv directory names and activates if found
VENV_DIRS=("venv" ".venv" "env")
VENV_ACTIVE=false

for DIR in "${VENV_DIRS[@]}"; do
    if [ -d "$ROOT_DIR/$DIR" ]; then
        echo "--> Activating virtual environment in $DIR..."
        source "$ROOT_DIR/$DIR/bin/activate"
        VENV_ACTIVE=true
        break
    fi
done

if [ "$VENV_ACTIVE" = false ]; then
    echo "--> Warning: No virtual environment detected. Using system Python."
fi

# 2. Addons Path Configuration
# Includes core addons and root addons directory
ADDONS_PATH="$ROOT_DIR/addons,$ROOT_DIR/odoo/addons"

# Check for a 'custom_addons' or 'enterprise' directory and add if present
if [ -d "$ROOT_DIR/custom_addons" ]; then
    ADDONS_PATH="$ADDONS_PATH,$ROOT_DIR/custom_addons"
fi

# 3. Configuration File
CONFIG_FILE="$ROOT_DIR/odoo.conf"

# 4. Execution
# We use 'exec' to replace the shell process with the Odoo process
# "$@" allows passing additional arguments like: ./start.local.sh -d my_db -u all
if [ -f "$CONFIG_FILE" ]; then
    echo "--> Starting Odoo with configuration: $CONFIG_FILE"
    exec python3.13 "$ROOT_DIR/odoo-bin" -c "$CONFIG_FILE" --addons-path="$ADDONS_PATH" "$@"
else
    echo "--> No odoo.conf found. Starting with default local parameters."
    echo "--> Addons path: $ADDONS_PATH"
    # Basic defaults for local development:
    # --dev=all: enables auto-reload and direct template editing
    exec python3.13 "$ROOT_DIR/odoo-bin" --addons-path="$ADDONS_PATH" --dev=all "$@"
fi
