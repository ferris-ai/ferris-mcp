---
name: whats-next
description: Look at what changed for the user in Ferris over the last few days and propose concrete next tasks. Use when the user asks what's new, what changed, what needs their attention, or what to work on next in Ferris.
---

# What's next in Ferris

Turn the user's recent Ferris activity into a short, ordered list of next actions.

## Steps

1. Call `list_my_recent_updates` with `days: 7`. If the user names a project, first get its id from `list_projects` and pass it as `project_id`. If the user asks about a shorter or longer period, set `days` from 1 to 14.
2. If the response has `has_more: true`, call again with a higher `limit` (up to 100). If it has `projects_skipped`, tell the user that some projects were left out, and offer to look at one project at a time.
3. Read the updates and decide what needs the user. Put them in this order:
   - `client_question`: a client is waiting for an answer.
   - `mention`: someone asked the user something.
   - `unblocked`: work the user can start now.
   - `assigned` and `meeting_action_item`: new work for the user.
   - `comment` and `updated`: changes to the user's tasks to review.
4. For the most important items, call `get_task` or `list_task_comments` when the reason alone does not say what to do.
5. Answer with three to five next actions. For each one, give:
   - the action, as one short sentence that starts with a verb ("Reply to Dana about the go-live date")
   - the project and task, with the task's link
   - why it matters now, in a few words
6. End with one line that lists the updates you did not include, grouped by type, so the user knows nothing was hidden.

## Rules

- Do not create, change, or comment on anything unless the user asks. Offer instead: "Want me to draft the reply to Dana?"
- If there are no updates, say so in one line and offer to look further back with a larger `days`.
- Use the dates in the updates. Say "yesterday" or "on Monday", not raw timestamps.
