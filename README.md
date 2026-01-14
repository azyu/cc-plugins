# Claude Plugins

A collection of plugins for Claude Code.

## Available Plugins

| Plugin | Description |
|--------|-------------|
| [codex-review-hook](./codex-review-hook) | Auto code review with OpenAI Codex before git commit |

## Installation

### 1. Add this marketplace

```bash
/plugin marketplace add github:jinto/claude-plugins
```

### 2. Install a plugin

```bash
/plugin install codex-review-hook@claude-plugins
```

## Creating Your Own Plugin

Each plugin should have this structure:

```
your-plugin/
├── .claude-plugin/
│   └── plugin.json       # Plugin metadata
├── hooks/
│   └── hooks.json        # Hook definitions
├── scripts/
│   └── your-script.sh    # Hook scripts
└── README.md             # Documentation
```

### plugin.json

```json
{
  "name": "your-plugin",
  "description": "What your plugin does",
  "version": "1.0.0",
  "author": { "name": "your-name" }
}
```

### hooks.json

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "ToolName",
        "hooks": [
          {
            "type": "command",
            "command": "$PLUGIN_DIR/scripts/your-script.sh"
          }
        ]
      }
    ]
  }
}
```

## License

MIT
