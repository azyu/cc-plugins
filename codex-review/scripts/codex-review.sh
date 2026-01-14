#!/bin/bash
# codex-review.sh
# Code review with OpenAI Codex

set -e

# Default values
MODEL="gpt-5.2-codex"
REASONING="high"
REVIEW_TYPE="uncommitted"
CUSTOM_PROMPT=""

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -m|--model)
            MODEL="$2"
            REASONING=""  # Don't set reasoning for custom models
            shift 2
            ;;
        staged)
            # Note: codex --uncommitted reviews all changes (staged + unstaged + untracked)
            # There's no staged-only option in codex CLI
            REVIEW_TYPE="uncommitted"
            shift
            ;;
        "last commit"|last-commit|--last-commit)
            REVIEW_TYPE="last-commit"
            shift
            ;;
        last)
            if [[ "$2" == "commit" ]]; then
                REVIEW_TYPE="last-commit"
                shift 2
            else
                CUSTOM_PROMPT="$CUSTOM_PROMPT $1"
                shift
            fi
            ;;
        uncommitted)
            REVIEW_TYPE="uncommitted"
            shift
            ;;
        -*)
            # Unknown option, skip
            shift
            ;;
        *)
            # Custom prompt
            CUSTOM_PROMPT="$CUSTOM_PROMPT $1"
            shift
            ;;
    esac
done

# Trim whitespace from custom prompt
CUSTOM_PROMPT=$(echo "$CUSTOM_PROMPT" | xargs)

# Check if codex is installed
if ! command -v codex &> /dev/null; then
    echo "Error: OpenAI Codex CLI is not installed."
    echo ""
    echo "To install:"
    echo "  npm install -g @openai/codex"
    echo "  codex auth"
    exit 1
fi

# Build model options
MODEL_OPTS="-m $MODEL"
if [[ -n "$REASONING" ]]; then
    MODEL_OPTS="$MODEL_OPTS -c model_reasoning_effort=\"$REASONING\""
fi

# Check for uncommitted changes if reviewing uncommitted (not staged, not last-commit)
if [[ "$REVIEW_TYPE" == "uncommitted" ]]; then
    CHANGES=$(git status --short 2>/dev/null || echo "")
    if [[ -z "$CHANGES" ]]; then
        echo "No uncommitted changes found. Reviewing last commit instead."
        echo ""
        REVIEW_TYPE="last-commit"
    fi
fi

# Build prompt option if custom prompt provided
PROMPT_OPT=""
if [[ -n "$CUSTOM_PROMPT" ]]; then
    PROMPT_OPT="\"$CUSTOM_PROMPT\""
fi

# Run the codex command based on review type
case "$REVIEW_TYPE" in
    last-commit)
        echo "Reviewing last commit..."
        echo ""
        if [[ -n "$PROMPT_OPT" ]]; then
            eval "codex exec review --commit HEAD $PROMPT_OPT $MODEL_OPTS --dangerously-bypass-approvals-and-sandbox"
        else
            eval "codex exec review --commit HEAD $MODEL_OPTS --dangerously-bypass-approvals-and-sandbox"
        fi
        ;;
    *)
        echo "Reviewing uncommitted changes..."
        echo ""
        if [[ -n "$PROMPT_OPT" ]]; then
            eval "codex exec review --uncommitted $PROMPT_OPT $MODEL_OPTS --dangerously-bypass-approvals-and-sandbox"
        else
            eval "codex exec review --uncommitted $MODEL_OPTS --dangerously-bypass-approvals-and-sandbox"
        fi
        ;;
esac
