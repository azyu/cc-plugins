# Codex Review

Run OpenAI Codex to review code changes.

## Arguments

The user may specify what to review:
- "uncommitted" or "uncommitted changes" - review all uncommitted changes (default)
- "staged" or "staged files" - review only staged changes
- "last commit" or "--last-commit" - review the last commit

## Instructions

1. Check if `codex` CLI is installed. If not, tell the user to install it:
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
/review                    # Review uncommitted changes
/review uncommitted        # Review uncommitted changes
/review staged             # Review staged files
/review last commit        # Review the last commit
/review --last-commit      # Review the last commit
```
