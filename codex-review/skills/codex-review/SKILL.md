---
name: codex-review
description: Review code changes with OpenAI Codex. Use for uncommitted changes, staged files, or last commit.
allowed-tools: Bash(codex:*), Bash(which:*)
user-invocable: true
---

# Codex Review

Run OpenAI Codex to review code changes.

## Arguments

The user may specify what to review:
- "uncommitted" or "uncommitted changes" - review all uncommitted changes (default)
- "staged" or "staged files" - review only staged changes
- "last commit" - review the last commit

## Instructions

1. Check if `codex` CLI is installed:
   ```bash
   which codex
   ```
   If not installed, tell the user:
   ```
   npm install -g @openai/codex
   codex auth
   ```

2. Based on the argument, run the appropriate codex command:
   - For uncommitted/staged changes: `codex exec review --uncommitted`
   - For last commit: `codex exec review --commit HEAD`

3. Display the review results to the user.

## Example Usage

```
/codex-review                    # Review uncommitted changes
/codex-review uncommitted        # Review uncommitted changes
/codex-review staged             # Review staged files
/codex-review last commit        # Review the last commit
```
