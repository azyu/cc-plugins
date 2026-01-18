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
/codex-review last commit               # Review the last commit
/codex-review last 3 commits            # Review last 3 commits
/codex-review last two commits          # Review last 2 commits
/codex-review against main              # Review current branch vs main (PR-style)
/codex-review --base develop            # Review current branch vs develop
/codex-review against main -m o3        # PR review with specific model
```

## Installation

```
/plugin marketplace add https://github.com/jinto/cc-plugins.git
/plugin install codex-review@cc-plugins
```

## License

MIT
