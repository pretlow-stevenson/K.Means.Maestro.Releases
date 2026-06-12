#!/usr/bin/env bash
set -euo pipefail

APP_PATH="${1:-./maestro}"
CONFIG_PATH="${2:-maestro.settings.json}"

echo "== Maestro smoke test =="
echo "app: ${APP_PATH}"
echo "config: ${CONFIG_PATH}"

"${APP_PATH}" --version
"${APP_PATH}" --doctor --config "${CONFIG_PATH}"

echo "smoke test passed"
