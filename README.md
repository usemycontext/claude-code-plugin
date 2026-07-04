# UseMyContext plugin marketplace for Claude Code

Your context follows you into the terminal. This repository is a Claude Code plugin marketplace that
distributes the **UseMyContext** plugin: sign in once and Claude Code reads your UseMyContext profile,
lists and opens your files, and answers from your documents, all read-only and audited. Map a folder to
one of your projects and every session in that folder reads the right context.

## Install

```
/plugin marketplace add usemycontext-ai/claude-code-plugin
/plugin install usemycontext@usemycontext
```

Then run `/mcp`, select `usemycontext`, and complete the browser sign-in. Full plugin docs, including how
folder-to-profile mapping works, are in [`usemycontext/README.md`](./usemycontext/README.md).

## Layout

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
    `-- README.md              # plugin documentation
```

## The boundary

This plugin scopes your CONTEXT per folder, that is, which UseMyContext profile the AI reads. It does not
change your Anthropic account, your Claude Code login, your billing, or which model runs.

## For maintainers: publishing

This directory is the full contents of the public marketplace repository. To publish or update it:

1. Copy the contents of this directory to the root of a public Git repository (for example
   `usemycontext-ai/claude-code-plugin`), so `.claude-plugin/marketplace.json` sits at the repo root and
   `usemycontext/` is the plugin directory.
2. Push to the default branch.
3. Users install with the two commands under [Install](#install) above.

Bump `version` in `usemycontext/.claude-plugin/plugin.json` on every release, otherwise Claude Code keeps
serving the cached copy. Nothing here deploys a worker or a Pages site; the plugin only needs this public
repository to exist. The live UseMyContext service it connects to is at
[usemycontext.ai](https://usemycontext.ai).
