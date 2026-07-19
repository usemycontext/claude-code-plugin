# UseMyContext for Claude Code

[MIT license](./LICENSE) | [usemycontext.ai](https://usemycontext.ai) | [Docs](https://usemycontext.ai/docs) | [`usemycontext` SDK on npm](https://www.npmjs.com/package/usemycontext)

UseMyContext is the personal context layer for AI. You keep one profile of who you are and what you are
working on, and any AI client reads it over MCP. This plugin brings that into the terminal: sign in once
and Claude Code answers with your context already in the room - who you are, what this project is to you,
what your documents say.

## What it looks like

```
cd ~/code/acme-api
claude

> Who am I, and what is this project to me?

  This folder is mapped to your @work context. You're a backend engineer
  at Acme, this repo is the payments API you own, and your notes say the
  current focus is the v2 billing migration. Want me to pull the migration
  checklist from your files?
```

No pasting your background into every session. The context is already there, scoped to the folder you
are in.

## Install

```
/plugin marketplace add usemycontext/claude-code-plugin
/plugin install usemycontext@usemycontext
```

Then run `/mcp`, select `usemycontext`, and complete the browser sign-in.

You will need:

- A UseMyContext account. The free tier is enough to try this. No account yet? Create a free one at
  [usemycontext.ai](https://usemycontext.ai) first.
- A current Claude Code (any version with `/plugin` support).

Sign-in is OAuth in the browser; no token is written to any file. This repo is also the plugin's
marketplace, which is why the install is two commands. The second command is `plugin@marketplace`;
both happen to be named `usemycontext`. Full reference docs, including the `.umc` format and the two
connection modes, are in [`usemycontext/README.md`](./usemycontext/README.md).

## Try it in 30 seconds

**No signup needed.** At the browser sign-in, use `demo@usemycontext.ai` with code `424242`
(fixed - no email access needed). A shared, read-only demo account with a full profile, files, and a
shared context. Then ask Claude Code "what do you know about me?". Docs:
[usemycontext.ai/docs](https://usemycontext.ai/docs)

## Disconnecting and revoking

You are never locked in:

- In Claude Code, run `/mcp` and disconnect `usemycontext`.
- Or revoke from the UseMyContext web app: the Connect page lists every AI connected right now, each
  with its own Disconnect button, plus a "Disconnect all".

Revoking is enforced on the server: the token dies immediately, everywhere. Nothing needs cleaning up
locally.

## What you get

Ask Claude Code things like "what do you know about me?", "summarize my notes on the Q3 launch", or
"how many rows in expenses.csv are over 500?" - it reads your profile, searches and opens your files,
answers from your documents with cited passages, and runs exact counts and sums over your spreadsheets.
A `/umc` skill checks or changes which profile a folder reads, and a SessionStart hook points every new
session at the right project automatically.

Under the hood: the UseMyContext MCP server at `https://mcp.usemycontext.ai/mcp` (Streamable HTTP,
OAuth 2.1) with eight tools - `profile`, `list_files`, `search_files`, `get_file`, `ask_docs`,
`query_table`, `suggest_update`, `shared_context` - all read-only against your files. One tool,
`suggest_update`, can write: it files a pending suggestion that you review and approve in the web app.
Nothing the AI does ever edits your profile or your files directly, and every read is logged to your
audit trail.

## One folder, one context

A work repo reads your @work profile. A side project reads your @personal one. Same terminal, different
context, chosen by the folder you are in.

To bind a folder to a project, drop a `.umc` file in the repo root
([`usemycontext/.umc.example`](./usemycontext/.umc.example) is a ready-made template):

```
projectId=p2
handle=@work
```

`projectId` is what scopes the reads. `handle` is an optional readable label. Find both in the web app
on the project's page, or just ask the `/umc` skill to create the file for you. With no `.umc`, the
folder reads your account's active profile.

## What it can and cannot do

- Reads: your profile and the files you uploaded to UseMyContext, scoped to the connected or mapped
  project.
- Writes: nothing to your files. The one write tool, `suggest_update`, files a pending suggestion that
  you review and approve in the web app.
- Every read is logged to your audit trail.
- You can revoke access at any time, from `/mcp` or from the web app's Connect page.
- It does not change your Anthropic account, your Claude Code login, your billing, or which model runs.

## Questions you probably have

**What does the AI actually see?** The profile you wrote and the files you uploaded to UseMyContext,
scoped to the connected or mapped project. Nothing else.

**Can it see my other projects?** The server only ever serves projects you own. With the default
account-wide sign-in, a folder reads its mapped project (or your active profile), and a request for any
project that is not yours is refused. If you want hard isolation per repo, use a single-project sign-in:
that token is scoped to one project and cannot read the others.

**Does it phone home from my repo?** No. The plugin reads only the local `.umc` marker to know which
profile to use. It never uploads your code or files; the only thing that travels is Claude's tool calls
to your UseMyContext account.

**What does it cost?** The plugin is free and MIT-licensed. UseMyContext has a free tier that covers
trying all of this; paid tiers are at [usemycontext.ai/pricing](https://usemycontext.ai/pricing).

## Repo layout (for contributors)

```
.
|-- .claude-plugin/
|   `-- marketplace.json      # the marketplace catalog (one plugin: usemycontext)
`-- usemycontext/             # the plugin
    |-- .claude-plugin/
    |   `-- plugin.json        # plugin manifest
    |-- .mcp.json              # registers the remote UseMyContext MCP server (OAuth)
    |-- skills/umc/SKILL.md    # the /umc skill (status + folder mapping)
    |-- hooks/hooks.json       # SessionStart hook
    |-- scripts/umc-session.sh # reads a folder's .umc marker
    |-- .umc.example           # example folder mapping
    `-- README.md              # reference docs for the plugin
```
