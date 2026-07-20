# UseMyContext for Claude Code

Reference docs for the plugin. Start with the [repo README](../README.md) if you are new.

Your personal context layer for AI, served to Claude Code over MCP. Sign in once and Claude Code can read
your UseMyContext profile, list and open your files, and answer from your documents, all read-only against
your files and audited.

## Install

```
/plugin marketplace add usemycontext/claude-code-plugin
/plugin install usemycontext@usemycontext
```

Then run `/mcp`, select `usemycontext`, and complete the browser sign-in (OAuth, no token stored in any
file). No account yet? Create a free one at [usemycontext.ai](https://usemycontext.ai) first.

**Try it in 30 seconds - no signup.** Sign in as `demo@usemycontext.ai` with code `424242` (fixed - no
email access needed). A shared, read-only demo account with a full profile, files, and a shared context.
Docs: [usemycontext.ai/docs](https://usemycontext.ai/docs)

## The `.umc` file

Each UseMyContext project has its own context and its own `@handle`. To bind a folder to a project, drop a
`.umc` file in the repo root ([`.umc.example`](./.umc.example) is a ready-made template):

```
projectId=p2
handle=@work
```

`projectId` (like `p2`) is what scopes the reads. `handle` is an optional readable label. Find both in the
UseMyContext web app on the project's page. The `/umc` skill can create or update this file for you.

With no `.umc`, the folder reads your account's active profile.

## The two connection modes

1. **Sign in once, map folders with `.umc` (the default - start here).** One account-wide sign-in; the
   `.umc` marker selects the project per folder. Under the hood, tool calls carry `projectId` from `.umc`,
   and the server verifies it is one of your own projects before scoping the read. The bundled `/umc`
   skill and SessionStart hook apply this for you.
2. **One sign-in per project (stricter).** Hard isolation per repo: connect with a single-project grant
   from the Connect chooser in the web app, and every tool is scoped to that one project - the token
   itself cannot read the others. To vary the project per folder this way, add the MCP server at project
   scope (a repo-local `.mcp.json`) and authenticate each repo to its project.

## The tools

The UseMyContext MCP server at `https://mcp.usemycontext.ai/mcp` (Streamable HTTP, OAuth 2.1), with all
eight tools:

| Tool | What it does |
|---|---|
| `profile` | Read your compiled profile |
| `list_files` | List your uploaded files |
| `search_files` | Find files by name |
| `get_file` | Open a file's extracted text |
| `ask_docs` | Answer from your documents, with cited passages |
| `query_table` | Exact counts, sums, and filters over a spreadsheet or CSV |
| `suggest_update` | Propose a profile update (pending until you approve) |
| `shared_context` | Read contexts others shared with you |

One tool, `suggest_update`, can write: it files a pending suggestion that you review and approve in the
web app. Nothing the AI does ever edits your profile or your files directly, and every access leaves a record in
your audit trail.

Also bundled: the `/umc` skill to check, set, or change which UseMyContext profile a folder reads, and a
SessionStart hook that reads a folder's `.umc` marker so a new session is already pointed at the right
project.

## Disconnecting and revoking

- In Claude Code, run `/mcp` and disconnect `usemycontext`.
- Or revoke from the UseMyContext web app: the Connect page lists every AI connected right now, each with
  its own Disconnect button, plus a "Disconnect all".

Revoking is enforced on the server: the token dies immediately, everywhere. Nothing needs cleaning up
locally.

## What it can and cannot do

- Reads: your profile and the files you uploaded to UseMyContext, scoped to the connected or mapped
  project.
- Writes: nothing to your files. The one write tool, `suggest_update`, files a pending suggestion that
  you review and approve in the web app.
- Every access leaves a record in your audit trail.
- You can revoke access at any time, from `/mcp` or from the web app's Connect page.
- It does not change your Anthropic account, your Claude Code login, your billing, or which model runs.

## Links

- Start here: the [repo README](../README.md)
- Docs: [usemycontext.ai/docs](https://usemycontext.ai/docs)
- Web app: [usemycontext.ai](https://usemycontext.ai)
- MCP endpoint: `https://mcp.usemycontext.ai/mcp`
- Example folder mapping: [`.umc.example`](./.umc.example)
