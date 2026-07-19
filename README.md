# UseMyContext plugin marketplace for Claude Code

Your personal context layer for AI follows you into the terminal. This repository is a Claude Code
plugin marketplace that distributes the **UseMyContext** plugin: sign in once and Claude Code reads your
UseMyContext profile, lists and opens your files, and answers from your documents, all read-only and
audited. Map a folder to one of your projects and every session in that folder reads the right context.

## Install

```
/plugin marketplace add usemycontext/claude-code-plugin
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
