# Agent notes

This repo packages the Ferris MCP server as a plugin for Claude Code, Codex and Cursor. The server at `https://api.tryferris.app/ferris/mcp` owns the tools. The plugin only points to it and adds skills.

## Keep the skills and README in step with the server

These files contain hand-written copies of the server's tool list. Nothing checks them automatically.

- The tool tables in `skills/ferris-project-tools/SKILL.md`.
- The tool reference tables in `README.md`, and any tool count in the README text.
- Any other skill that names a tool.

When the server adds, removes or renames a tool or argument, update all of these.

- Name only tools and arguments that the server lists. A model that calls an unlisted argument gets an error.
- To check, call `tools/list` on the server. For each tool, compare `inputSchema.properties` with the arguments in the tables. Then compare `inputSchema.required` with the Required column. You can omit `limit` and `offset` from list tools.

## Build the OpenAI directory ZIP

The OpenAI plugin directory rejects a ZIP that contains `apps` or `.app.json` (error `app_configuration_excluded`). The Codex manifest uses `.app.json` for installs from this repo's marketplace. For the directory ZIP, swap `apps` for `mcpServers` in a copy of the manifest, and leave `.app.json` out.

Run these commands from the repo root:

```bash
staging_dir="$(mktemp -d)"
cp -R .codex-plugin .mcp.json skills assets README.md LICENSE "$staging_dir/"
jq 'with_entries(if .key == "apps" then {key: "mcpServers", value: "./.mcp.json"} else . end)' \
  .codex-plugin/plugin.json > "$staging_dir/.codex-plugin/plugin.json"
rm -f ferris-openai-plugin.zip
(cd "$staging_dir" && zip -qr "$OLDPWD/ferris-openai-plugin.zip" . -x '*.DS_Store')
rm -rf "$staging_dir"
```

Keep these steps here, not in a script file. The Claude plugin directory refuses scripts from organizations that are not Verified.

This repo is public on GitHub. Do not add internal repo names, file paths, ticket ids or hostnames.
