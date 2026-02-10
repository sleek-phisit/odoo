#!/bin/bash

# Odoo Background Startup Script
# ------------------------------

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
LOG_FILE="$ROOT_DIR/odoo.log"

echo "--> Starting Odoo in the background..."
echo "--> Logs will be available at: $LOG_FILE"

# Run start.sh in the background and redirect all output to odoo.log
nohup "$ROOT_DIR/start.sh" "$@" > "$LOG_FILE" 2>&1 &

# Save the PID to a file for easy stopping later
echo $! > "$ROOT_DIR/odoo.pid"

echo "--> Odoo started with PID: $(cat "$ROOT_DIR/odoo.pid")"
echo "--> To stop Odoo, run: kill \$(cat "$ROOT_DIR/odoo.pid")"
