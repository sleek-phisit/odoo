#!/bin/bash

# Odoo Graceful Shutdown Script
# ----------------------------

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
PID_FILE="$ROOT_DIR/odoo.pid"

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p $PID > /dev/null; then
        echo "--> Sending SIGTERM to Odoo (PID: $PID) for graceful shutdown..."
        kill -15 $PID
        
        # Wait for the process to actually stop
        COUNT=0
        while ps -p $PID > /dev/null && [ $COUNT -lt 30 ]; do
            sleep 1
            ((COUNT++))
            echo -n "."
        done
        echo ""

        if ps -p $PID > /dev/null; then
            echo "--> Odoo did not stop gracefully. Forcing shutdown..."
            kill -9 $PID
        else
            echo "--> Odoo stopped gracefully."
        fi
        rm "$PID_FILE"
    else
        echo "--> Process $PID not running. Cleaning up stale PID file."
        rm "$PID_FILE"
    fi
else
    # Fallback: try to find the process if pid file is missing
    PID=$(pgrep -f "odoo-bin")
    if [ ! -z "$PID" ]; then
        echo "--> Found Odoo process $PID. Sending SIGTERM..."
        kill -15 $PID
    else
        echo "--> No Odoo process found."
    fi
fi
