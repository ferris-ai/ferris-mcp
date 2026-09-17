# Ferris

Manage [Ferris](https://tryferris.app) projects, documents, tasks, and knowledge search from your AI assistant. This plugin connects your coding agent to the Ferris MCP server, giving it access to 23 project management tools.

## What It Does

Gives your AI agent access to Ferris project tools — search project knowledge bases, look up Ferris product how-to and other software docs, manage tasks, browse documents, review team members, and track project activity. All operations are scoped to projects you have access to via your Ferris account.

## Install

### Claude.ai

1. Go to **Settings > Connectors > Add custom connector**
2. Paste the server URL: `https://api.tryferris.app/ferris/mcp`
3. Complete the OAuth flow to connect your Ferris account

Requires a Claude Pro, Max, Team, or Enterprise plan.

### ChatGPT

1. Go to **Settings > MCP** (or search for MCP servers)
2. Add a custom MCP server with the URL: `https://api.tryferris.app/ferris/mcp`
3. Complete the OAuth flow to connect your Ferris account

### Cursor

**One-click install:**

[Install Ferris in Cursor](cursor://anysphere.cursor-deeplink/mcp/install?name=ferris&config=eyJ1cmwiOiJodHRwczovL2FwaS50cnlmZXJyaXMuYXBwL2ZlcnJpcy9tY3AifQ%3D%3D)

Or install from the Cursor Marketplace: search for "ferris" in Customize.

### Claude Code

**Via plugin marketplace:**

```
/plugin marketplace add ferris-ai/ferris-mcp
/plugin install ferris-mcp@ferris
```

**Or add the MCP server directly:**

```bash
claude mcp add --transport http --scope user ferris https://api.tryferris.app/ferris/mcp
```

Then authenticate by running `/mcp` in a Claude Code session and completing the OAuth flow.

### Codex

**Via plugin directory:**

Install from the Codex Plugin Directory, or add the marketplace:

```bash
codex plugin marketplace add ferris-ai/ferris-mcp
```

**Or add the MCP server directly:**

```bash
codex mcp add ferris --url https://api.tryferris.app/ferris/mcp
```

Then authenticate:

```bash
codex mcp login ferris
```

## Authentication

This MCP server uses OAuth 2.1. On first connection, your AI assistant will prompt you to authenticate with your Ferris account. The OAuth flow opens your browser, you log in (or confirm if already logged in), and the token is stored automatically.

## Tool Reference

### Organizations and Projects

| Tool | Description |
|------|-------------|
| `list_organizations` | List all organizations the user belongs to with roles |
| `list_projects` | List accessible projects, optionally filter by name |
| `get_project` | Get full details of a project by ID |
| `create_project` | Create a new project in an organization |
| `update_project` | Update project name, description, or language |
| `archive_project` | Soft-delete a project (can be restored) |
| `delete_project` | Permanently delete a project (irreversible) |

### Documents

| Tool | Description |
|------|-------------|
| `list_documents` | List document metadata with optional filters |
| `get_document` | Get full metadata for a specific document |
| `get_document_content` | Get the full text content of a document |
| `get_document_summary` | Get AI-generated summary of a document |

### Tasks

| Tool | Description |
|------|-------------|
| `list_tasks` | List tasks with status, assignee, and epic filters |
| `search_tasks` | Full-text search tasks by keyword |
| `get_task` | Get full task details including assignees |
| `create_task` | Create a new task with title, priority, assignees, dates |
| `update_task` | Update task fields (status, priority, description, etc.) |
| `delete_task` | Soft-delete (cancel) a task |
| `list_task_changes` | View task change history (audit log) |

### Search

| Tool | Description |
|------|-------------|
| `search_project_context` | Semantic search over project knowledge (meetings, documents, notes) |
| `search_software_context` | Search software docs on a project (`ferris-documentation` for Ferris how-to; other banks for Qualtrics/EngineHire/etc.) |

### People

| Tool | Description |
|------|-------------|
| `list_project_members` | List human team members with names, emails, roles |
| `list_project_actors` | List all actors (members, contacts, agents) for task assignment |
| `list_task_comments` | List comments on a task with threaded replies |

See `skills/ferris-project-tools/SKILL.md` for detailed usage guidance and workflow examples.

## Plugin Structure

```
ferris-mcp-plugins/
├── .cursor-plugin/plugin.json     # Cursor plugin manifest
├── .claude-plugin/
│   ├── plugin.json                # Claude Code plugin manifest
│   └── marketplace.json           # Claude Code marketplace catalog
├── .codex-plugin/plugin.json      # OpenAI Codex plugin manifest
├── skills/
│   └── ferris-project-tools/
│       └── SKILL.md               # Agent skill with workflow guidance
├── mcp.json                       # Cursor MCP server config
├── .mcp.json                      # Claude Code / Codex MCP server config
├── assets/
│   └── logo.svg                   # Plugin logo
└── README.md
```

## License

MIT
