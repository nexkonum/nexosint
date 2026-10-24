#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
PYTHON_BIN="${PYTHON_BIN:-python3}"
if [[ ! -x .venv/bin/python ]]; then "$PYTHON_BIN" -m venv .venv; fi
.venv/bin/python -m pip install --upgrade pip
.venv/bin/python -m pip install -r requirements.txt
printf '\nNEX OSINT Pro: http://127.0.0.1:8000\nAPI docs: http://127.0.0.1:8000/api/docs\nKeep this terminal open while using the app.\n\n'
exec .venv/bin/python -m uvicorn app:app --host 127.0.0.1 --port 8000
