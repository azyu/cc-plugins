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
/codex-review                    # Review uncommitted changes
/codex-review uncommitted        # Review uncommitted changes
/codex-review staged             # Review staged files
/codex-review last commit        # Review the last commit
```

## License

MIT
