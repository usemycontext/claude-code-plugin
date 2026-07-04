#!/usr/bin/env sh
# UseMyContext Claude Code plugin - SessionStart hook.
#
# Reads the per-folder ".umc" marker in the project root and tells the session
# which UseMyContext profile this folder is bound to. Plain stdout reaches
# Claude for SessionStart, so this just prints the mapping - no JSON, no jq, no
# dependencies (POSIX sh + grep + sed).
#
# The ".umc" marker is a tiny key=value file, for example:
#   projectId=p2
#   handle=@work
#
# No marker, or an empty one, means this folder uses your account's active
# UseMyContext profile - the hook stays quiet so unmapped repos are untouched.

marker="${CLAUDE_PROJECT_DIR:-.}/.umc"
[ -f "$marker" ] || exit 0

read_value() {
  grep -E "^[[:space:]]*$1[[:space:]]*=" "$marker" 2>/dev/null \
    | head -n1 \
    | sed -E 's/^[^=]*=[[:space:]]*//; s/[[:space:]]*$//'
}

project_id=$(read_value projectId)
handle=$(read_value handle)

[ -z "$project_id" ] && [ -z "$handle" ] && exit 0

label="$project_id"
[ -n "$handle" ] && label="$handle${project_id:+ ($project_id)}"

printf 'UseMyContext: this folder is mapped to your "%s" context.\n' "$label"

if [ -n "$project_id" ]; then
  printf 'On every UseMyContext MCP tool call (profile, list_files, search_files, get_file, ask_docs, query_table, suggest_update), pass the argument projectId="%s" so this session reads the mapped project. This applies when your UseMyContext connection is account-wide; a single-project connection is already scoped and ignores the argument.\n' "$project_id"
fi
