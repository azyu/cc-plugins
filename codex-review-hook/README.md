# codex-review-hook

Claude Code plugin that automatically runs OpenAI Codex code review before `git commit`.

## Features

- Intercepts `git commit` commands via PreToolUse hook
- Runs `codex exec review --uncommitted` automatically
- Returns only the final review result to Claude (saves context)
- Gracefully handles missing Codex installation

## Prerequisites

Install OpenAI Codex CLI:

```bash
npm install -g @openai/codex
codex auth
```

## Installation

```bash
# Add the marketplace
/plugin marketplace add jinto/cc-plugins

# Install this plugin
/plugin install codex-review-hook@cc-plugins
```

## How It Works

1. When Claude runs a `git commit` command, this hook intercepts it
2. Runs `codex exec review --uncommitted` to analyze staged changes
3. Extracts the review comment from Codex output
4. Passes the review to Claude as a system message
5. Claude can then address any issues before committing

## Example Output

When you commit, Claude will receive something like:

```
[codex-review-hook] Code Review Result:

The changes look good overall. Consider:
- Adding error handling for edge cases in the new function
- The variable naming could be more descriptive
```

## License

MIT
