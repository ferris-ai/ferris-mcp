#!/usr/bin/env bash
# Build the ZIP for the OpenAI plugin directory.
#
# The directory rejects ZIPs that contain `apps` or `.app.json`
# (error `app_configuration_excluded`). The Codex manifest in this repo
# references the published app through `.app.json`, for installs from this
# repo's marketplace. This script swaps `apps` for `mcpServers` in a copy of
# the manifest and leaves `.app.json` out of the ZIP.
#
# Usage: scripts/build-openai-zip.sh [output.zip]

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
output_path="$(cd "$(dirname "${1:-ferris-openai-plugin.zip}")" && pwd)/$(basename "${1:-ferris-openai-plugin.zip}")"
staging_dir="$(mktemp -d)"
trap 'rm -rf "$staging_dir"' EXIT

cd "$repo_root"
cp -R .codex-plugin .mcp.json skills assets README.md LICENSE "$staging_dir/"

python3 - "$staging_dir/.codex-plugin/plugin.json" <<'PYTHON'
import json
import sys

manifest_path = sys.argv[1]

with open(manifest_path) as manifest_file:
    manifest = json.load(manifest_file)

manifest = {
    ("mcpServers" if key == "apps" else key): ("./.mcp.json" if key == "apps" else value)
    for key, value in manifest.items()
}

with open(manifest_path, "w") as manifest_file:
    json.dump(manifest, manifest_file, indent=2, ensure_ascii=False)
    manifest_file.write("\n")
PYTHON

rm -f "$output_path"
(cd "$staging_dir" && zip -qr "$output_path" . -x '*.DS_Store')
echo "Wrote $output_path"
