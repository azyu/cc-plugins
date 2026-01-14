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

# Run codex review
REVIEW_OUTPUT=$(codex exec review --uncommitted 2>&1)
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

# Extract only the review comment (after "Review comment:" line)
REVIEW_COMMENT=$(echo "$REVIEW_OUTPUT" | sed -n '/Review comment:/,$p' | tail -n +2)

if [ -z "$REVIEW_COMMENT" ]; then
    # No review comment found, use full output
    REVIEW_COMMENT="$REVIEW_OUTPUT"
fi

# Escape for JSON
ESCAPED_COMMENT=$(echo "$REVIEW_COMMENT" | jq -Rs '.')

# Return system message with review
cat << EOF
{
    "systemMessage": "[codex-review-hook] Code Review Result:\n\n${ESCAPED_COMMENT}"
}
EOF
