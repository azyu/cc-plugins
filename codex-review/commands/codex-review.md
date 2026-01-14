---
description: Review code changes with OpenAI Codex. Use for uncommitted changes, staged files, last commit, or custom review prompts.
allowed-tools: Bash(codex:*), Bash(which:*)
---

Review code changes using OpenAI Codex.

## Arguments

The user may specify:
- "uncommitted" or "uncommitted changes" - review all uncommitted changes (default)
- "staged" or "staged files" - review only staged changes
- "last commit" - review the last commit
- Any custom message - use as review prompt (e.g., "check for security issues")

## Instructions

1. Check if `codex` CLI is installed by running `which codex`
   - If not installed, tell the user to run:
     ```
     npm install -g @openai/codex
     codex auth
     ```

2. Based on the argument, run the appropriate codex command:
   - For uncommitted/staged/no args: `codex exec review --uncommitted`
   - For last commit: `codex exec review --commit HEAD`
   - For custom message: `codex exec review --uncommitted "<user's message>"`

3. Display the review results to the user.
