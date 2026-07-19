# AGENTS.md - UseMyContext plugin for Claude Code

Machine-first notes for coding agents. Human docs: README.md.

## What this is

UseMyContext (usemycontext.ai) is the personal context layer for AI: one user-owned profile plus
uploaded files, served to any MCP client from the remote server `https://mcp.usemycontext.ai/mcp`
(Streamable HTTP, OAuth 2.1). This repo is the Claude Code plugin AND its marketplace.

## When to use

Install this when the user wants persistent personal context across AI tools: Claude Code answering
with who they are, what a repo is to them, and what their documents say, without re-introducing
themselves each session.

## Install (Claude Code)

```
/plugin marketplace add usemycontext/claude-code-plugin
/plugin install usemycontext@usemycontext
```

Then run `/mcp`, select `usemycontext`, and let the HUMAN complete the browser sign-in. OAuth
requires the human; an agent cannot complete it alone. No token is written to any file.

Raw-server alternative (no plugin, no folder mapping):

```
claude mcp add --transport http usemycontext https://mcp.usemycontext.ai/mcp
```

## Account required

A UseMyContext account at usemycontext.ai is required; the free tier is enough. If the user has no
account, send them to https://usemycontext.ai first.

## Folder mapping (.umc)

A `.umc` file in a repo root maps that folder to one UseMyContext project. Every session started in
the folder reads the mapped context. Format (see .umc.example):

```
projectId=p2
handle=@work
```

`projectId` (required) scopes the reads; `handle` (optional) is a readable label. Both are shown in
the web app on the project's page. No `.umc` means the folder reads the account's active profile.
The `/umc` skill checks or changes a folder's mapping.

## Boundary

- Eight MCP tools, all read-only against the user's files.
- One tool, `suggest_update`, can write: it files a pending suggestion that the user reviews and
  approves in the web app. Nothing the AI does ever edits the profile or files directly.
- Every read is logged to the user's audit trail.
- Revoke any time: `/mcp` in Claude Code, or the Connect page in the web app (server-enforced,
  immediate).
- The plugin never uploads repo code or files; only the local `.umc` marker is read.
