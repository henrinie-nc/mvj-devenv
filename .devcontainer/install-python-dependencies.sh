#!/usr/bin/env bash

set -euo pipefail

api_dir="/workspace/api"

# Remove possibly conflicting packages from the devcontainer image.
if command -v pipx >/dev/null 2>&1; then
    pipx uninstall black >/dev/null 2>&1 || true
    pipx uninstall mypy >/dev/null 2>&1 || true
    pipx uninstall pytest >/dev/null 2>&1 || true
fi

if [[ ! -f "$api_dir/requirements.txt" || ! -f "$api_dir/requirements-dev.txt" ]]; then
    echo "API requirements files are not available at $api_dir." >&2
    exit 1
fi

python -m pip install --upgrade pip
python -m pip install \
    -r "$api_dir/requirements.txt" \
    -r "$api_dir/requirements-dev.txt"
python -m pip install pip-tools