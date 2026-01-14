# codex-review

Code review with OpenAI Codex for Claude Code.

## Prerequisites

Install OpenAI Codex CLI:

```bash
npm install -g @openai/codex
codex auth
```

## Usage

```
/review                    # Review uncommitted changes
/review uncommitted        # Review uncommitted changes
/review staged             # Review staged files
/review last commit        # Review the last commit
/review --last-commit      # Review the last commit
```

## Installation

```
/plugin install codex-review@cc-plugins
```

## License

MIT
