# Ferris

[Ferris](https://tryferris.ai) acts as your project manager for delivery work. It keeps client projects on track by managing tasks, changes, and meetings. This plugin connects your AI assistant to the Ferris MCP server, so it can find what changed for you, keep tasks and issues up to date, and answer questions from your project knowledge: meetings, documents, and notes.

Every call runs as your Ferris account. The assistant can only see and change projects that you can see and change in Ferris.

## Install

The Ferris MCP server URL is:

```
https://api.tryferris.app/ferris/mcp
```

Each option below connects to that server. On the first connection, your assistant opens a browser window to sign in to Ferris (see [Authentication](#authentication)).

### Claude Code

Install the plugin, which adds the MCP server and the Ferris skills:

```
/plugin install ferris --marketplace https://github.com/ferris-ai/ferris-mcp.git
```

On Claude Code versions before 2.1.275, add the marketplace first:

```
/plugin marketplace add ferris-ai/ferris-mcp
/plugin install ferris@ferris
```

Or add only the MCP server:

```bash
claude mcp add --transport http --scope user ferris https://api.tryferris.app/ferris/mcp
```

Then run `/mcp` in a Claude Code session and sign in.

### Codex

Install the plugin:

```bash
codex plugin marketplace add https://github.com/ferris-ai/ferris-mcp.git
codex plugin add ferris@ferris
```

Or add only the MCP server, then sign in:

```bash
codex mcp add ferris --url https://api.tryferris.app/ferris/mcp
```

```bash
codex mcp login ferris
```

### Cursor

[Install Ferris in Cursor](cursor://anysphere.cursor-deeplink/mcp/install?name=ferris&config=eyJ1cmwiOiJodHRwczovL2FwaS50cnlmZXJyaXMuYXBwL2ZlcnJpcy9tY3AifQ%3D%3D) (opens Cursor and adds the MCP server).

### Claude and ChatGPT

Add a custom connector with the server URL above, then sign in to Ferris when asked. Custom connectors depend on your plan and workspace settings.

## Authentication

The server uses OAuth 2.1. Your assistant opens a browser window, you sign in to Ferris (or confirm if you are already signed in), and the assistant stores the token. You can sign in with Google, an email magic link, or an email and password if your account has one.

## Skills

| Skill | What it does |
| ----- | ------------ |
| `/ferris:whats-next` | Looks at what changed for you in the last few days and proposes concrete next tasks. |
| `ferris-project-tools` | Guidance the assistant uses when it works with Ferris projects, tasks, documents, and search. |

## Example prompts

- "What's new for me in Ferris this week?"
- "Summarize the open tasks on the Acme rollout project and who owns each one."
- "Search the Acme project for the decisions from last week's kickoff."
- "Create a task on the Acme project to send the API keys, due Friday, assigned to me."

## Tool reference

Tools marked **Write (destructive)** delete, cancel, remove, overwrite, or send something that cannot be taken back. Most assistants ask you to confirm before they run them.

### Your updates

| Tool | Access | What it does |
| ---- | ------ | ------------ |
| `list_my_recent_updates` | Read | List what changed for you in Ferris over the last few days, across your projects: tasks assigned to you, changes and new comments on your open tasks, @-mentions of you, client questions you own, tasks that were unblocked, and action items from recent meetings. |

### Organizations and projects

| Tool | Access | What it does |
| ---- | ------ | ------------ |
| `list_organizations` | Read | List all organizations the authenticated user belongs to, including the user's role in each. |
| `list_projects` | Read | List the projects you can see, with each project's id, name, description, organization, and client account. |
| `get_project` | Read | Get full details of a specific project by ID. |
| `update_project` | Write (destructive) | Update a project's fields. |

### Project team

| Tool | Access | What it does |
| ---- | ------ | ------------ |
| `list_project_members` | Read | People on the project team: name, email, and role. |
| `list_project_actors` | Read | People and agents you can assign or mention. |
| `list_project_contacts` | Read | Account contacts placed on this project. |
| `add_project_member` | Write | Put an organization member on a project with their org title, and set up their assistant. |
| `remove_project_member` | Write (destructive) | Take a member off a project. |
| `add_project_contact` | Write | Place an existing account contact on a project. |
| `update_project_contact` | Write (destructive) | Change a contact's role or primary flag on one project. |
| `remove_project_contact` | Write (destructive) | Take a contact off a project. |

### Tasks and issues

| Tool | Access | What it does |
| ---- | ------ | ------------ |
| `list_tasks` | Read | List tasks on a project, filtered by status, epic, assignee, or kind (general, issue, or administrative). |
| `search_tasks` | Read | Search a project's board tasks by keyword in their title and description. |
| `get_task` | Read | Get details for a single task including assignees. |
| `create_task` | Write | Create a board task on a project. |
| `update_task` | Write (destructive) | Change a task. |
| `cancel_task` | Write (destructive) | Cancel a task. It stays in Ferris with status `cancelled`. |
| `list_issues` | Read | List issue tasks for a project. |
| `get_issue` | Read | One issue. |
| `list_task_attachments` | Read | List a task's attachments: reference files, drafts, and published deliverables. |
| `get_attachment_download_url` | Read | Get a short-lived download link for one task attachment. |

### Task comments

| Tool | Access | What it does |
| ---- | ------ | ------------ |
| `list_task_comments` | Read | List the note comments on a task, oldest first, with threaded replies and @-mentions. |
| `create_task_comment` | Write | Post a note comment on a task. |
| `update_task_comment` | Write (destructive) | Edit the body of a note comment you authored. |
| `delete_task_comment` | Write (destructive) | Delete a note comment you authored, including its @-mentions. |

### Epics and requirements

| Tool | Access | What it does |
| ---- | ------ | ------------ |
| `list_epics` | Read | Epics (deliverables) on a project, each with the requirement_ids it satisfies. |
| `get_epic` | Read | Get one epic on a project, with the requirement_ids it satisfies. |
| `create_epic` | Write | Create an epic (a deliverable) on a project. |
| `update_epic` | Write (destructive) | Change an epic. |
| `cancel_epic` | Write (destructive) | Cancel an epic. Its tasks stay and lose the epic link. |
| `list_requirements` | Read | List the project's requirements: the conditions the delivered result must meet. |
| `bulk_create_requirements` | Write | Create requirements on a project (1-50). |
| `update_requirement` | Write (destructive) | Change a requirement. |
| `delete_requirement` | Write (destructive) | Delete a requirement and its epic links. |

### Documents and search

| Tool | Access | What it does |
| ---- | ------ | ------------ |
| `list_documents` | Read | List documents (metadata only, no content). |
| `get_document` | Read | Get one document's metadata by id: filename, display_name, document_type, processing status, file_size, mime_type, its external link, a summary when one exists, and when it was added and processed. |
| `get_document_summary` | Read | Get a single document's AI-generated summary and metadata (works for both project and org-level documents). |
| `upload_document` | Write | Upload a file to a project or an organization and start processing. |
| `list_generated_artifacts` | Read | List the documents Ferris produced and published to the Project Library, newest first. |
| `get_artifact_download_url` | Read | Get a short-lived download link for a generated artifact. |
| `search_project_context` | Read | Semantic search over a project's knowledge base. |
| `search_software_context` | Read | Search a software platform's documentation for this project. |

### Meetings

| Tool | Access | What it does |
| ---- | ------ | ------------ |
| `add_ferris_to_meeting` | Write | Send Ferris to a Meet, Zoom, or Teams call to capture the transcript. |

### Client accounts and contacts

| Tool | Access | What it does |
| ---- | ------ | ------------ |
| `list_accounts` | Read | List client companies (accounts) in an organization. |
| `get_account` | Read | One client company (account). |
| `create_account` | Write | Create a client company (account) in an organization. |
| `update_account` | Write (destructive) | Change a client company. |
| `list_account_contacts` | Read | People who belong to a client company. |
| `get_account_contact` | Read | One person on a client company. |
| `create_account_contact` | Write | Add a person to a client company. |
| `update_account_contact` | Write (destructive) | Change a person on a client company. |

### Organization members and labels

| Tool | Access | What it does |
| ---- | ------ | ------------ |
| `list_org_members` | Read | People in an organization: user_id, name, email, org role (owner, admin, member, viewer), and title. |
| `update_org_member` | Write (destructive) | Change a person's org role or title. |
| `invite_org_member` | Write (destructive) | Email an invitation to join the organization. |
| `list_org_invitations` | Read | Invitations that have not been accepted yet. |
| `revoke_org_invitation` | Write (destructive) | Withdraw an invitation that has not been accepted. |
| `list_org_labels` | Read | Labels an organization defines. |
| `create_org_label` | Write | Add a label to an organization. |
| `update_org_label` | Write (destructive) | Rename or restyle a label. |
| `archive_org_label` | Write (destructive) | Hide a label from pickers. |

See [skills/ferris-project-tools/SKILL.md](skills/ferris-project-tools/SKILL.md) for each tool's inputs and example workflows.

## Plugin structure

```
ferris-mcp-plugins/
├── .claude-plugin/
│   ├── plugin.json                # Claude Code plugin manifest
│   └── marketplace.json           # Marketplace catalog (Claude Code and Codex)
├── .codex-plugin/plugin.json      # Codex plugin manifest
├── .cursor-plugin/plugin.json     # Cursor plugin manifest
├── skills/
│   ├── ferris-project-tools/
│   │   └── SKILL.md               # Tool guidance and workflows
│   └── whats-next/
│       └── SKILL.md               # /ferris:whats-next
├── .mcp.json                      # MCP server config (Claude Code, Codex)
├── mcp.json                       # MCP server config (Cursor)
├── assets/
│   └── logo.svg
├── LICENSE
└── README.md
```

## Support

Email support@tryferris.ai for help with the plugin, the MCP server or your Ferris account. To report a problem with this repository, open an issue on GitHub.

- Privacy policy: https://tryferris.ai/legal/privacy-policy
- Terms of service: https://tryferris.ai/legal/terms-of-service

## License

MIT. See [LICENSE](LICENSE).
