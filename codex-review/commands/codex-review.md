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
- `-m <model>` - use a specific model (e.g., `-m o3`)
- Any other text - custom review prompt

## Examples

```
/codex-review
/codex-review last commit
/codex-review -m o3
/codex-review check for security issues
```
