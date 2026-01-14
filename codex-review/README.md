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
/codex-review                           # Review uncommitted changes
/codex-review staged                    # Review staged files
/codex-review last commit               # Review the last commit
/codex-review check for security issues # Custom review prompt
```

## Installation

```
/plugin marketplace add https://github.com/jinto/cc-plugins.git
/plugin install codex-review@cc-plugins
```

## License

MIT
