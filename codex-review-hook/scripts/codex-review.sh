#!/bin/bash
# codex-review.sh
# Runs OpenAI Codex review before git commit

# Read hook input from stdin
INPUT=$(cat)

# Extract command from hook input
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Only process git commit commands
if [[ ! "$COMMAND" =~ ^git[[:space:]]+commit ]]; then
    # Not a git commit, pass through
    echo '{}'
    exit 0
fi

# Check if codex is installed
if ! command -v codex &> /dev/null; then
    cat << 'EOF'
{
    "systemMessage": "[codex-review-hook] OpenAI Codex is not installed.\n\nTo install:\n  npm install -g @openai/codex\n  codex auth\n\nSkipping code review."
}
EOF
    exit 0
fi

# Check if there are uncommitted changes
if git diff --cached --quiet 2>/dev/null; then
    # No staged changes
    echo '{}'
    exit 0
fi

# Run codex review (bypass sandbox - review is read-only anyway)
REVIEW_OUTPUT=$(codex exec review --uncommitted --dangerously-bypass-approvals-and-sandbox 2>&1)
CODEX_EXIT=$?

if [ $CODEX_EXIT -ne 0 ]; then
    # Codex failed, but don't block the commit
    MESSAGE=$(echo "$REVIEW_OUTPUT" | jq -Rs '.')
    cat << EOF
{
    "systemMessage": "[codex-review-hook] Codex review failed: $MESSAGE\n\nProceeding with commit anyway."
}
EOF
    exit 0
fi

# Extract only the final review (last "codex" block)
# The output format has "codex\n<review text>" at the end
REVIEW_COMMENT=$(echo "$REVIEW_OUTPUT" | tac | sed -n '1,/^codex$/p' | tac | tail -n +2)

if [ -z "$REVIEW_COMMENT" ]; then
    # Fallback: try to get last non-empty lines
    REVIEW_COMMENT=$(echo "$REVIEW_OUTPUT" | tail -5)
fi

# Clean up the comment - remove quotes if wrapped
REVIEW_COMMENT=$(echo "$REVIEW_COMMENT" | sed 's/^"//;s/"$//')

# Return system message with review (properly escaped)
ESCAPED_COMMENT=$(printf '%s' "$REVIEW_COMMENT" | jq -Rs '.')

cat << EOF
{
    "systemMessage": "[codex-review-hook] Code Review:\n\n${ESCAPED_COMMENT}"
}
EOF
