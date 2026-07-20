---
name: umc
description: Manage how this folder connects to UseMyContext. Use when the user wants to check which UseMyContext profile the current folder is reading, map this folder to one of their @handle profiles, or change or remove that mapping. Also use to explain how the folder-to-profile mapping works.
---

# UseMyContext in Claude Code

UseMyContext (usemycontext.ai) hosts your personal context and serves it to any AI client over MCP.
This plugin registers the UseMyContext MCP server, so once you sign in, Claude Code can read your
profile, list and open your files, and answer from your documents. Everything is read-only against your
files and audited.

Each of your UseMyContext projects has its own context and its own `@handle`. This skill lets you map a
folder to one project, so a work repo reads your work profile and a side project reads your personal one.

## Status: which profile is this folder using

1. Look for a `.umc` file in the project root (the directory Claude Code was started in).
2. If `.umc` exists, read its `projectId` and optional `handle` and report the mapping plainly, for
   example: `This folder is mapped to your "@work" context (p2).`
3. If there is no `.umc` file, tell the user this folder has no mapping, so UseMyContext tool calls read
   their account's active profile. Offer to create a mapping.

The `.umc` file is a small key=value file:

```
projectId=p2
handle=@work
```

`projectId` is what actually scopes the reads. `handle` is optional and only for a readable label (and for
reading a public project by handle). Find both in the UseMyContext web app under the project you want.

## Map this folder to a profile

1. Ask the user which project this folder should use, by `@handle` or project name.
2. Get that project's `projectId` (like `p2`). If the user only knows the `@handle` or the name, point
   them to usemycontext.ai to read the `projectId` from that project's page. Do not guess a `projectId`.
3. Write (or update) `.umc` in the project root with `projectId=<id>` and, if known, `handle=<@handle>`.
4. Suggest adding `.umc` to the repo (commit it) if the whole team should share the mapping, or to
   `.gitignore` if it is personal.

To remove a mapping, delete `.umc`. The folder then reads the account's active profile.

## How the mapping takes effect

There are two supported ways to make a folder read a specific project. Both work today.

### Account-wide connection plus the `.umc` marker (this plugin's default)

You sign in to UseMyContext once, with an account-wide grant (the default). A `.umc` marker in a folder
then selects the project for that folder:

- On every UseMyContext MCP tool call, include the argument `projectId="<the .umc projectId>"`. The tools
  are `profile`, `list_files`, `search_files`, `get_file`, `ask_docs`, `query_table`, and `suggest_update`
  (in Claude Code they appear as `mcp__plugin_usemycontext_usemycontext__<tool>`). One tool,
  `suggest_update`, can write: it files a pending suggestion that you review and approve in the web app.
  Nothing the AI does ever edits your profile or your files directly, and every access leaves a record in your
  audit trail.
- The UseMyContext server verifies the `projectId` is one of your own projects and scopes the read to it.
  If the `projectId` is not yours it refuses; if it is missing it falls back to your active project.
- The plugin's SessionStart hook reads `.umc` and reminds the session of this rule automatically, so a new
  session in a mapped folder is already pointed at the right project.

### Single-project connection (scopes every tool with no marker)

Alternatively, connect this folder with a single-project grant using the Connect chooser in the
UseMyContext web app. The connection token then carries that one project, so every tool call is scoped to
it automatically and the `projectId` argument is ignored. To vary the project by folder this way, add the
UseMyContext MCP server at project scope (a repo-local `.mcp.json`) and authenticate each repo to its own
project.

## Sign in

If the tools are not connected yet, run `/mcp`, select `usemycontext`, and complete the browser sign-in.
UseMyContext uses OAuth, so no token is stored in any file. New users can create an account at
usemycontext.ai first.

## The boundary, stated plainly

This plugin scopes your context per folder, that is, which UseMyContext profile the AI reads. It does not
change your Anthropic account, your Claude Code login, your billing, or which model runs. Keeping separate
Anthropic accounts or usage per folder is a different thing and is not what this does.
