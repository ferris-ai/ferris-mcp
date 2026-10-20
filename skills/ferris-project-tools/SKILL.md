---
name: ferris-project-tools
description: Work with Ferris projects, tasks, issues, epics, requirements, documents, meetings, and client contacts, and search project or Ferris product knowledge. Use when working with client projects, tracking tasks, reviewing documents, searching project context, or answering how Ferris itself works.
---

# Ferris Project Tools

Use the Ferris MCP tools to find what changed, search project knowledge, and manage tasks and documents. Every tool runs as the signed-in Ferris user and only reaches projects that user can access.

## When to Use

- Finding what changed for the user recently, or what to work on next (`list_my_recent_updates`)
- Searching project knowledge for meetings, decisions, documents, and notes
- Answering how Ferris itself works (Inbox, Tasks, Chat, client portal, magic links, meetings, knowledge, sync, workflows, agents, integrations) with `search_software_context` and bank `ferris-documentation`
- Looking up third-party platform docs (Qualtrics, EngineHire, and others) attached to a project
- Creating, updating, or tracking tasks, issues, epics, and requirements
- Browsing project documents and their summaries
- Looking up project members, contacts, and actors for task assignment

## Key Workflow Pattern

For "what's new" or "what should I do next" questions, start with `list_my_recent_updates`. It works across all of the user's projects and needs no ids.

Most other tools need a `project_id`. Get it from `list_projects` (optionally with `name_filter`), then pass it to the other calls.

To pick the right search tool:

- Client engagement knowledge (meetings, decisions, SOW, people, project documents) → `search_project_context`
- How Ferris itself works → `search_software_context` with `bank: "ferris-documentation"`
- How a connected platform works (Qualtrics, EngineHire, etc.) → `search_software_context` with that bank's name

Do not use `search_software_context` for what happened on an engagement. Do not use `search_project_context` for Ferris product how-to.

## Rules the server enforces

- A tool refuses inputs it does not list. Send only the inputs in the tables below.
- Ids are UUIDs. A task number like `97` is not a `task_id`; get the id from `list_tasks` or `search_tasks`.
- List tools page with `limit` and `offset`. When a response has `has_more: true`, call again with a higher `offset`.
- Task and epic `assignees` are objects with `actor_id` (from `list_project_actors`) and a RACI `raci_role`: `responsible`, `accountable`, `consulted`, or `informed`. Sending `assignees` replaces the whole set.

Task statuses: `backlog`, `pending`, `in_progress`, `review`, `blocked`, `completed`, `cancelled`. Priorities: `critical`, `high`, `medium`, `low`.

## Search notes

`search_project_context` searches all project knowledge: meetings, documents, and notes. Use `document_ids` from `list_documents` to search only those documents.

`search_software_context` searches a software bank attached to the project:

- `bank: "ferris-documentation"`: Ferris product how-to
- Other banks (`qualtrics`, `enginehire`, ...): third-party platform docs enabled on the project

If the bank is not enabled on the project, the tool returns the banks that are. Ask complete questions, not keywords. If a Ferris how-to result is an overview page, run one follow-up query for the related topic.

Use Ferris how-to facts in your answer without citing them, and do not mention the bank name. Third-party banks may include a `source_url`, which you can cite.

## Tool Reference

### Your updates

| Tool | Required | Optional |
| ---- | -------- | -------- |
| `list_my_recent_updates` | -- | `days`, `project_id`, `limit` |

### Organizations and projects

| Tool | Required | Optional |
| ---- | -------- | -------- |
| `list_organizations` | -- | -- |
| `list_projects` | -- | `name_filter`, `limit`, `offset` |
| `get_project` | `project_id` | -- |
| `update_project` | `project_id` | `name`, `description`, `language` |

### Project team

| Tool | Required | Optional |
| ---- | -------- | -------- |
| `list_project_members` | `project_id` | -- |
| `list_project_actors` | `project_id` | `actor_type` |
| `list_project_contacts` | `project_id` | -- |
| `add_project_member` | `project_id`, `user_id` | `member_subtype`, `is_primary` |
| `remove_project_member` | `project_id`, `user_id` | -- |
| `add_project_contact` | `project_id`, `account_contact_id` | `role`, `is_primary` |
| `update_project_contact` | `project_id`, `account_contact_id` | `role`, `is_primary` |
| `remove_project_contact` | `project_id`, `account_contact_id` | -- |

### Tasks and issues

| Tool | Required | Optional |
| ---- | -------- | -------- |
| `list_tasks` | `project_id` | `kind`, `status`, `epic_id`, `assigned_actor_id`, `mentioned_actor_id`, `limit`, `offset` |
| `search_tasks` | `project_id`, `query` | `status`, `epic_id`, `priority`, `assigned_actor_id`, `limit`, `offset` |
| `get_task` | `project_id`, `task_id` | -- |
| `create_task` | `project_id`, `title` | `status`, `description`, `priority`, `epic_id`, `assignees`, `estimated_days`, `due_date`, `start_date`, `portal_task_state`, `kind` |
| `update_task` | `project_id`, `task_id` | `title`, `description`, `status`, `priority`, `epic_id`, `assignee_ids`, `assignees`, `estimated_days`, `due_date`, `start_date`, `resolution`, `reason`, `portal_task_state` |
| `cancel_task` | `project_id`, `task_id`, `reason` | -- |
| `list_issues` | `project_id` | `status`, `limit`, `offset` |
| `get_issue` | `project_id`, `issue_id` | -- |
| `update_issue` | `project_id`, `issue_id` | `title`, `description`, `status`, `priority`, `epic_id`, `assignee_ids`, `assignees`, `estimated_days`, `due_date`, `start_date`, `reason` |
| `resolve_issue` | `project_id`, `issue_id`, `resolution` | -- |
| `list_task_attachments` | `project_id`, `task_id` | -- |
| `get_attachment_download_url` | `project_id`, `task_id`, `attachment_id` | `expires_in_minutes` |

### Task comments

| Tool | Required | Optional |
| ---- | -------- | -------- |
| `list_task_comments` | `project_id`, `task_id` | `limit`, `offset` |
| `create_task_comment` | `project_id`, `task_id`, `body` | `parent_comment_id`, `mention_actor_ids` |
| `update_task_comment` | `project_id`, `comment_id`, `body` | -- |
| `delete_task_comment` | `project_id`, `comment_id` | -- |

### Epics and requirements

| Tool | Required | Optional |
| ---- | -------- | -------- |
| `list_epics` | `project_id` | `status`, `requirement_id`, `limit`, `offset` |
| `get_epic` | `project_id`, `epic_id` | -- |
| `create_epic` | `project_id`, `title` | `status`, `description`, `priority`, `requirement_ids`, `start_date`, `due_date`, `assignees` |
| `update_epic` | `project_id`, `epic_id` | `title`, `description`, `status`, `priority`, `requirement_ids`, `start_date`, `due_date`, `assignees` |
| `cancel_epic` | `project_id`, `epic_id` | -- |
| `list_requirements` | `project_id` | `status`, `uncovered_only`, `limit`, `offset` |
| `bulk_create_requirements` | `project_id`, `items` | -- |
| `update_requirement` | `project_id`, `requirement_id` | `title`, `description`, `requirement_type`, `status`, `acceptance_criteria`, `source`, `sort_order`, `assignees` |
| `delete_requirement` | `project_id`, `requirement_id` | -- |

### Documents and search

| Tool | Required | Optional |
| ---- | -------- | -------- |
| `list_documents` | `project_id` | `scope`, `document_type`, `status`, `since`, `until`, `query`, `limit`, `offset` |
| `get_document` | `document_id` | -- |
| `get_document_summary` | `project_id`, `document_id` | -- |
| `upload_document` | `filename`, `content_base64` | `project_id`, `organization_id` |
| `list_generated_artifacts` | `project_id` | `since`, `until`, `format`, `source`, `limit`, `offset` |
| `get_artifact_download_url` | `project_id`, `artifact_id` | `expires_in_minutes` |
| `search_project_context` | `project_id`, `query` | `document_ids`, `limit` |
| `search_software_context` | `project_id`, `query`, `bank` | `limit` |

### Meetings

| Tool | Required | Optional |
| ---- | -------- | -------- |
| `add_ferris_to_meeting` | `title`, `meeting_url` | `start_time`, `transcript_language`, `project_id`, `organization_id` |

### Client accounts and contacts

| Tool | Required | Optional |
| ---- | -------- | -------- |
| `list_accounts` | `organization_id` | `limit`, `offset` |
| `get_account` | `account_id` | -- |
| `create_account` | `organization_id`, `name` | `description`, `website`, `industry` |
| `update_account` | `account_id` | `name`, `description`, `website`, `industry` |
| `list_account_contacts` | `account_id` | `limit`, `offset` |
| `get_account_contact` | `account_contact_id` | -- |
| `create_account_contact` | `account_id`, `first_name`, `last_name` | `email`, `phone`, `title`, `is_primary`, `project_id`, `project_role` |
| `update_account_contact` | `account_contact_id` | `first_name`, `last_name`, `email`, `phone`, `title`, `is_primary` |

### Organization members and labels

| Tool | Required | Optional |
| ---- | -------- | -------- |
| `list_org_members` | `organization_id` | `limit`, `offset` |
| `update_org_member` | `organization_id`, `user_id` | `role`, `title_id` |
| `invite_org_member` | `organization_id`, `email` | `role`, `title_id`, `project_id` |
| `list_org_invitations` | `organization_id` | `limit`, `offset` |
| `revoke_org_invitation` | `invitation_id` | -- |
| `list_org_labels` | `organization_id` | `type` |
| `create_org_label` | `organization_id`, `type`, `name` | `description`, `color` |
| `update_org_label` | `label_id` | `name`, `description`, `color`, `sort_order` |
| `archive_org_label` | `label_id` | -- |

## Common Workflows

### What's new for me

```json
{ "tool": "list_my_recent_updates", "arguments": { "days": 7 } }
```

Each update has a `type` (`assigned`, `unblocked`, `updated`, `comment`, `mention`, `client_question`, `meeting_action_item`), a date, the project and task, a link, and a short reason.

### Find and search a project's knowledge

```json
// 1. Find the project
{ "tool": "list_projects", "arguments": { "name_filter": "Acme" } }

// 2. Search its knowledge
{ "tool": "search_project_context", "arguments": {
  "project_id": "<project_id>",
  "query": "What were the key decisions from the kickoff meeting?"
} }
```

### Look up how Ferris itself works

```json
{ "tool": "search_software_context", "arguments": {
  "project_id": "<project_id>",
  "query": "How do magic links work for the client portal?",
  "bank": "ferris-documentation"
} }
```

### Create a task from discovered context

```json
// 1. Search for context
{ "tool": "search_project_context", "arguments": {
  "project_id": "<project_id>",
  "query": "action items from last week"
} }

// 2. Find who to assign
{ "tool": "list_project_actors", "arguments": { "project_id": "<project_id>" } }

// 3. Create the task
{ "tool": "create_task", "arguments": {
  "project_id": "<project_id>",
  "title": "Follow up on API integration timeline",
  "priority": "high",
  "due_date": "2026-08-15",
  "assignees": [{ "actor_id": "<actor_id>", "raci_role": "responsible" }]
} }
```

### Review a document

```json
// 1. List project documents
{ "tool": "list_documents", "arguments": { "project_id": "<project_id>" } }

// 2. Get the summary
{ "tool": "get_document_summary", "arguments": {
  "project_id": "<project_id>",
  "document_id": "<document_id>"
} }

// 3. Search inside it for details
{ "tool": "search_project_context", "arguments": {
  "project_id": "<project_id>",
  "query": "What does the SOW say about payment terms?",
  "document_ids": ["<document_id>"]
} }
```
