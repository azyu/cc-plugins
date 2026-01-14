#!/bin/bash
# codex-review.sh
# Code review with OpenAI Codex

set -e

# Default values
MODEL="gpt-5.2-codex"
REASONING="high"
REVIEW_TYPE="uncommitted"
COMMIT_COUNT=1
CUSTOM_PROMPT=""

# Convert word numbers to digits
word_to_number() {
    case "$1" in
        one|1) echo 1 ;;
        two|2) echo 2 ;;
        three|3) echo 3 ;;
        four|4) echo 4 ;;
        five|5) echo 5 ;;
        six|6) echo 6 ;;
        seven|7) echo 7 ;;
        eight|8) echo 8 ;;
        nine|9) echo 9 ;;
        ten|10) echo 10 ;;
        *) echo "" ;;
    esac
}

# Collect all arguments for parsing
ARGS=("$@")
ARGS_STR="${ARGS[*]}"

# Check for "last N commit(s)" pattern first
if [[ "$ARGS_STR" =~ ^last[[:space:]]+([a-z0-9]+)[[:space:]]+(commit|commits)$ ]]; then
    NUM=$(word_to_number "${BASH_REMATCH[1]}")
    if [[ -n "$NUM" ]]; then
        REVIEW_TYPE="commits"
        COMMIT_COUNT="$NUM"
        set -- # Clear remaining args
    fi
fi

# Parse remaining arguments
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
            REVIEW_TYPE="commits"
            COMMIT_COUNT=1
            shift
            ;;
        last)
            if [[ "$2" == "commit" ]]; then
                REVIEW_TYPE="commits"
                COMMIT_COUNT=1
                shift 2
            else
                NUM=$(word_to_number "$2")
                if [[ -n "$NUM" && ( "$3" == "commit" || "$3" == "commits" ) ]]; then
                    REVIEW_TYPE="commits"
                    COMMIT_COUNT="$NUM"
                    shift 3
                else
                    CUSTOM_PROMPT="$CUSTOM_PROMPT $1"
                    shift
                fi
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

# Check for uncommitted changes if reviewing uncommitted
if [[ "$REVIEW_TYPE" == "uncommitted" ]]; then
    CHANGES=$(git status --short 2>/dev/null || echo "")
    if [[ -z "$CHANGES" ]]; then
        echo "No uncommitted changes found. Reviewing last commit instead."
        echo ""
        REVIEW_TYPE="commits"
        COMMIT_COUNT=1
    fi
fi

# Run the codex command based on review type
case "$REVIEW_TYPE" in
    commits)
        if [[ "$COMMIT_COUNT" -eq 1 ]]; then
            echo "Reviewing last commit..."
            COMMIT_REF="HEAD"
        else
            echo "Reviewing last $COMMIT_COUNT commits..."
            COMMIT_REF="HEAD~$((COMMIT_COUNT-1))..HEAD"
        fi
        echo ""
        if [[ -n "$CUSTOM_PROMPT" ]]; then
            eval "codex exec review --commit $COMMIT_REF \"$CUSTOM_PROMPT\" $MODEL_OPTS --dangerously-bypass-approvals-and-sandbox"
        else
            eval "codex exec review --commit $COMMIT_REF $MODEL_OPTS --dangerously-bypass-approvals-and-sandbox"
        fi
        ;;
    *)
        echo "Reviewing uncommitted changes..."
        echo ""
        # Note: codex doesn't support custom prompts with --uncommitted
        eval "codex exec review --uncommitted $MODEL_OPTS --dangerously-bypass-approvals-and-sandbox"
        ;;
esac
