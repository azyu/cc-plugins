---
description: Review code changes with OpenAI Codex. Use for uncommitted changes, staged files, last commit, or custom review prompts.
allowed-tools: Bash(${CLAUDE_PLUGIN_ROOT}/scripts/codex-review.sh:*)
---

Review code changes using OpenAI Codex.

Run the script with user's arguments:
```
${CLAUDE_PLUGIN_ROOT}/scripts/codex-review.sh <arguments>
```

## Arguments

- (no args) - review uncommitted changes, fallback to last commit if none
- `last commit` - review the last commit
- `last N commits` - review last N commits (e.g., `last 3 commits`, `last two commits`)
- `against <branch>` - review current branch against target branch (PR-style review)
- `--base <branch>` - same as `against <branch>`
- `-m <model>` - use a specific model (e.g., `-m o3`)

## Examples

```
/codex-review
/codex-review last commit
/codex-review last 3 commits
/codex-review last two commits
/codex-review against main
/codex-review --base develop
/codex-review against main -m o3
```
