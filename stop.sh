#!/bin/bash

# Odoo Stop Script
# ----------------

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
PID_FILE="$ROOT_DIR/odoo.pid"

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    echo "--> Stopping Odoo (PID: $PID)..."
    kill "$PID" && rm "$PID_FILE"
    echo "--> Odoo stopped."
else
    echo "--> No odoo.pid found. Odoo might not be running in the background."
fi
