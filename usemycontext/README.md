# UseMyContext for Claude Code

Your personal context layer for AI, served to Claude Code over MCP. Sign in once and Claude Code can read
your UseMyContext profile, list and open your files, and answer from your documents, all read-only and audited.

Map a folder to one of your projects, and every Claude Code session in that folder reads the right
context: a work repo reads your work profile, a side project reads your personal one.

## Install

```
/plugin marketplace add usemycontext/claude-code-plugin
/plugin install usemycontext@usemycontext
```

Then run `/mcp`, select `usemycontext`, and complete the browser sign-in (OAuth, no token stored in any
file). Do not have an account yet? Create one at [usemycontext.ai](https://usemycontext.ai) first.

## What you get

- The UseMyContext MCP server at `https://mcp.usemycontext.ai/mcp` (Streamable HTTP, OAuth 2.1), with all
  eight tools: `profile`, `list_files`, `search_files`, `get_file`, `ask_docs`, `query_table`,
  `suggest_update`, `shared_context`.
- A `/umc` skill to check, set, or change which UseMyContext profile a folder reads.
- A SessionStart hook that reads a folder's `.umc` marker so a new session is already pointed at the right
  project.

## Folder to profile mapping

Each UseMyContext project has its own context and its own `@handle`. To bind a folder to a project, drop a
`.umc` file in the repo root:

```
projectId=p2
handle=@work
```

`projectId` (like `p2`) is what scopes the reads. `handle` is an optional readable label. Find both in the
UseMyContext web app on the project's page. The `/umc` skill can create or update this file for you.

With no `.umc`, the folder reads your account's active profile.

### How it takes effect

Two supported ways, both work today:

1. **Account-wide sign-in plus the `.umc` marker (the default).** You sign in once with an account-wide
   grant. In a mapped folder, tool calls carry `projectId` from `.umc`, and the server verifies it is one
   of your own projects before scoping the read. The bundled `/umc` skill and SessionStart hook apply this
   for you.
2. **Single-project sign-in.** Connect with a single-project grant using the Connect chooser in the web
   app. Every tool is then scoped to that one project automatically, no marker needed. To vary the project
   per folder this way, add the MCP server at project scope (a repo-local `.mcp.json`) and authenticate
   each repo to its project.

## The boundary

This plugin scopes your CONTEXT per folder, that is, which UseMyContext profile the AI reads. It does not
change your Anthropic account, your Claude Code login, your billing, or which model runs.

## Links

- Web app: [usemycontext.ai](https://usemycontext.ai)
- MCP endpoint: `https://mcp.usemycontext.ai/mcp`
