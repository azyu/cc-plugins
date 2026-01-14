# CC Plugins

A collection of plugins for Claude Code.

## Available Plugins

| Plugin | Description |
|--------|-------------|
| [codex-review](./codex-review) | Code review with OpenAI Codex |

## Installation

### 1. Add this marketplace

```bash
/plugin marketplace add https://github.com/jinto/cc-plugins.git
```

### 2. Install a plugin

```bash
/plugin install codex-review@cc-plugins
```

## Usage

```
/codex-review                           # Review uncommitted changes
/codex-review last commit               # Review the last commit
/codex-review last 3 commits            # Review last 3 commits
/codex-review last two commits          # Review last 2 commits
```

Default model: `gpt-5.2-codex` with `reasoning effort: high`

To use a different model:
```
/codex-review -m o3
/codex-review -m gpt-4
```

## License

MIT
