---
description: Review code changes with OpenAI Codex. Use for uncommitted changes, staged files, last commit, or custom review prompts.
allowed-tools: Bash(codex:*), Bash(which:*), Bash(git status:*), Bash(git diff:*)
---

Review code changes using OpenAI Codex.

## Arguments

The user may specify:
- "uncommitted" or "uncommitted changes" - review all uncommitted changes (default)
- "staged" or "staged files" - review only staged changes
- "last commit" - review the last commit
- Any custom message - use as review prompt (e.g., "check for security issues")
- "-m <model>" - use a specific model (e.g., "-m o3", "-m gpt-4")

## Instructions

1. Check if `codex` CLI is installed by running `which codex`
   - If not installed, tell the user to run:
     ```
     npm install -g @openai/codex
     codex auth
     ```

2. Parse the arguments:
   - If user specified `-m <model>`, use that model
   - Otherwise, use default: `-m gpt-5.2-codex -c model_reasoning_effort="high"`

3. If user didn't specify "last commit":
   - First check if there are uncommitted changes: `git status --short`
   - If no uncommitted changes, automatically review the last commit instead
   - Tell the user: "No uncommitted changes found. Reviewing last commit instead."

4. Run the appropriate codex command:
   - For uncommitted/staged: `codex exec review --uncommitted <model_options> --dangerously-bypass-approvals-and-sandbox`
   - For last commit: `codex exec review --commit HEAD <model_options> --dangerously-bypass-approvals-and-sandbox`
   - For custom message: `codex exec review --uncommitted "<user's message>" <model_options> --dangerously-bypass-approvals-and-sandbox`

5. Display the review results to the user.
