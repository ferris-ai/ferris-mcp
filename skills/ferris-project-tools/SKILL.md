---
name: ferris-project-tools
description: Manage Ferris projects, documents, tasks, and search project or Ferris product knowledge. Use when working with client projects, tracking tasks, reviewing documents, searching project context, or answering how Ferris itself works.
---

# Ferris Project Tools

Use the Ferris MCP tools to manage projects, search knowledge, track tasks, and browse documents. All tools operate on Ferris projects accessible to the authenticated user.

## When to Use

- Managing client engagement projects (create, update, archive)
- Searching project knowledge bases for meeting notes, documents, and context
- Answering how Ferris itself works (Inbox, Tasks, Chat, client portal, magic links, meetings, knowledge, sync, workflows, agents, integrations) via `search_software_context` with bank `ferris-documentation`
- Looking up third-party platform docs (Qualtrics, EngineHire, and others) attached to a project
- Creating, updating, or tracking tasks across projects
- Browsing or reading project documents and their summaries
- Looking up project team members and actors for task assignment
- Reviewing task history and comment threads

## Key Workflow Pattern

Most tools require a `project_id`. Start by listing projects to get the ID, then use it across all other calls:

1. `list_organizations` -- find the organization
2. `list_projects` -- find the project (optionally filter by name)
3. Use `project_id` with all other tools

When searching for information, prefer the right search tool before asking the user:

- Client engagement knowledge (meetings, decisions, SOW, people, project documents) → `search_project_context`
- How Ferris itself works → `search_software_context` with `bank: "ferris-documentation"`
- How a connected platform works (Qualtrics, EngineHire, etc.) → `search_software_context` with that bank's internal name

Do not use `search_software_context` for what happened on an engagement. Do not use `search_project_context` as a substitute for Ferris product how-to.

## Tool Reference

### Organizations and Projects

| Tool | Required | Optional | Description |
| ---- | -------- | -------- | ----------- |
| `list_organizations` | -- | -- | List all orgs the user belongs to with roles |
| `list_projects` | -- | `name_filter` | List accessible projects, optionally filter by name |
| `get_project` | `project_id` | -- | Get full project details |
| `create_project` | `organization_id`, `name` | `description`, `project_mode`, `language` | Create a new project |
| `update_project` | `project_id` | `name`, `description`, `language` | Update project fields |
| `archive_project` | `project_id` | -- | Soft-delete a project |
| `delete_project` | `project_id` | -- | Permanently delete a project (irreversible) |

### Documents

| Tool | Required | Optional | Description |
| ---- | -------- | -------- | ----------- |
| `list_documents` | `project_id` | `scope`, `document_type`, `status`, `since`, `until`, `limit`, `offset` | List document metadata (no content) |
| `get_document` | `document_id` | -- | Get full document metadata |
| `get_document_content` | `document_id` | -- | Get full text content of a document |
| `get_document_summary` | `project_id`, `document_id` | -- | Get AI-generated summary of a document |

`list_documents` supports filtering by `scope` (`project` or `organization`), `document_type` (`knowledge`, `template`, `promoted_artifact`), and `status` (`uploaded`, `parsing`, `parsed`, `failed`, `analyzed`).

### Tasks

| Tool | Required | Optional | Description |
| ---- | -------- | -------- | ----------- |
| `list_tasks` | `project_id` | `status`, `epic_id`, `assigned_actor_id`, `mentioned_actor_id`, `limit`, `offset` | List tasks with optional filters |
| `search_tasks` | `project_id`, `query` | `status`, `epic_id`, `priority`, `assigned_actor_id`, `limit`, `offset` | Full-text search tasks by keyword |
| `get_task` | `project_id`, `task_id` | -- | Get full task details including assignees |
| `create_task` | `project_id`, `title` | `status`, `description`, `priority`, `epic_id`, `assignee_ids`, `due_date`, `start_date`, `source`, `creation_reason`, `metadata` | Create a task |
| `update_task` | `project_id`, `task_id` | `title`, `description`, `status`, `priority`, `epic_id`, `assignee_ids`, `due_date`, `start_date`, `metadata`, `work_summary` | Update task fields |
| `delete_task` | `project_id`, `task_id` | -- | Soft-delete (cancel) a task |
| `list_task_changes` | `project_id`, `task_id` | `since`, `limit`, `offset` | View task change history (audit log) |

Task statuses: `backlog`, `pending`, `in_progress`, `review`, `blocked`, `completed`, `cancelled`.

Priority levels: `critical`, `high`, `medium`, `low`.

Use `list_tasks` for filtering by status/assignee/epic. Use `search_tasks` when you need keyword matching in title and description.

### Search

| Tool | Required | Optional | Description |
| ---- | -------- | -------- | ----------- |
| `search_project_context` | `project_id`, `query` | `document_ids`, `limit` | Semantic search over project knowledge |
| `search_software_context` | `project_id`, `query`, `bank` | `limit` | Search software platform documentation enabled on the project |

`search_project_context` searches across all project knowledge -- meetings, documents, notes. Use `document_ids` to scope results to specific documents (get IDs from `list_documents` first).

`search_software_context` searches a software bank attached to that project:

- `bank: "ferris-documentation"` — Ferris product how-to (Inbox, Tasks, Chat, client portal, magic links, meetings, knowledge, sync, workflows, agents, integrations)
- Other banks (`qualtrics`, `enginehire`, …) — third-party platform documentation enabled on the project

If the bank is not enabled on the project, the tool returns the banks that are.

Use Ferris how-to facts in your answer without citing them. Do not include source URLs or a Sources line for Ferris product documentation, and do not mention the bank name to the user. Third-party banks may include `source_url` and can be cited.

Ask complete questions, not keywords. If a Ferris how-to hit is a hub/overview page, run one follow-up `search_software_context` query for the related topic (depth 2).

### People

| Tool | Required | Optional | Description |
| ---- | -------- | -------- | ----------- |
| `list_project_members` | `project_id` | -- | List human team members with names, emails, roles |
| `list_project_actors` | `project_id` | `actor_type`, `filter_valid_assignees` | List all actors (members, contacts, agents) |
| `list_task_comments` | `project_id`, `task_id` | `limit`, `offset` | List comments on a task |

Use `list_project_actors` with `filter_valid_assignees=true` to get actor UUIDs for task assignment. Actor types: `member`, `contact`, `agent`.

## Common Workflows

### Find and search a project's knowledge

```json
// 1. Find the project
{ "tool": "list_projects", "arguments": { "name_filter": "Acme" } }

// 2. Search its knowledge base
{ "tool": "search_project_context", "arguments": {
  "project_id": "<id>",
  "query": "What were the key decisions from the kickoff meeting?"
} }
```

### Look up how Ferris itself works

```json
{ "tool": "search_software_context", "arguments": {
  "project_id": "<id>",
  "query": "How do magic links work for the client portal?",
  "bank": "ferris-documentation"
} }
```

Do not include source URLs for Ferris product documentation in the answer.

### Create a task from discovered context

```json
// 1. Search for context
{ "tool": "search_project_context", "arguments": {
  "project_id": "<id>",
  "query": "action items from last week"
} }

// 2. Get assignable actors
{ "tool": "list_project_actors", "arguments": {
  "project_id": "<id>",
  "filter_valid_assignees": true
} }

// 3. Create the task
{ "tool": "create_task", "arguments": {
  "project_id": "<id>",
  "title": "Follow up on API integration timeline",
  "priority": "high",
  "assignee_ids": ["<actor_id>"],
  "due_date": "2026-08-15",
  "creation_reason": "Action item from weekly status meeting"
} }
```

### Review a document

```json
// 1. List project documents
{ "tool": "list_documents", "arguments": { "project_id": "<id>" } }

// 2. Get the AI summary
{ "tool": "get_document_summary", "arguments": {
  "project_id": "<id>",
  "document_id": "<doc_id>"
} }

// 3. Read full content if needed
{ "tool": "get_document_content", "arguments": { "document_id": "<doc_id>" } }
```
