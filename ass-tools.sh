#!/usr/bin/env bash
# =============================================================================
# ASS Tools — Agentic Super Search
# Install: copy each function into your ~/.bashrc or ~/.zshrc, then source it
# Requires: claude CLI in PATH
# =============================================================================

# -----------------------------------------------------------------------------
# guardrails — security checkpoint before eval
# -----------------------------------------------------------------------------
guardrails() {
  # YOLO
  echo "$1"
}

# -----------------------------------------------------------------------------
# dumbass — brute-force grep + summarize
# Usage: dumbass "search query"
# -----------------------------------------------------------------------------
dumbass() {
  local query="$*"
  if [[ -z "$query" ]]; then
    echo "Usage: dumbass <search query>" >&2
    return 1
  fi

  echo "🔍 Searching for: $query" >&2

  grep -rIi -C 5 "$query" . \
    | claude -p "Aggregate and summarize the grep results below to answer this question: \"$query\". Be concise."
}

# -----------------------------------------------------------------------------
# badass — Claude generates the grep command, runs it, then summarizes
# Usage: badass "search query"
# -----------------------------------------------------------------------------
badass() {
  local query="$*"
  if [[ -z "$query" ]]; then
    echo "Usage: badass <search query>" >&2
    return 1
  fi

  echo "🧠 Generating search command for: $query" >&2

  local grep_cmd
  grep_cmd=$(claude -p "You are a command generator. Output ONLY a single grep command on one line. No explanation, no markdown, no backticks, no other text. The command must start with 'grep'. Search the current directory recursively for content relevant to: \"$query\". Use grep -rIi with appropriate flags and pattern." | head -1)

  if [[ "$grep_cmd" != grep* ]]; then
    echo "⚠️  Failed to generate a search command" >&2
    return 1
  fi

  echo "⚙️  Running: $grep_cmd" >&2

  guardrails "$grep_cmd" | bash 2>/dev/null \
    | claude -p "Aggregate and summarize the grep results below to answer this question: \"$query\". Be concise."
}

# -----------------------------------------------------------------------------
# hardass — looping search with Claude self-verification (max N iterations)
# Usage: hardass "search query" [max_iterations=5]
# -----------------------------------------------------------------------------
hardass() {
  local query="$*"
  local max_iter=5

  if [[ "${@: -1}" =~ ^[0-9]+$ ]]; then
    max_iter="${@: -1}"
    query="${*:1:$#-1}"
  fi

  if [[ -z "$query" ]]; then
    echo "Usage: hardass <search query> [max_iterations]" >&2
    return 1
  fi

  local current_query="$query"
  local iter=1
  local answer=""
  local verdict=""

  while [[ $iter -le $max_iter ]]; do
    echo "🔄 Iteration $iter/$max_iter — Query: \"$current_query\"" >&2

    local grep_cmd
    grep_cmd=$(claude -p "You are a command generator. Output ONLY a single grep command on one line. No explanation, no markdown, no backticks, no other text. The command must start with 'grep'. Search the current directory recursively for content relevant to: \"$current_query\". Use grep -rIi with appropriate flags and pattern." | head -1)

    if [[ "$grep_cmd" != grep* ]]; then
      echo "⚠️  Failed to generate a search command" >&2
      ((iter++))
      continue
    fi

    local raw_results
    raw_results=$(guardrails "$grep_cmd" | bash 2>/dev/null)

    answer=$(echo "$raw_results" \
      | claude -p "Aggregate and summarize the grep results below to answer this question: \"$current_query\". Be concise. If the results are empty or insufficient, say so explicitly.")

    verdict=$(claude -p "You are a strict QA judge. The user asked: \"$query\".
The search query used was: \"$current_query\".
The answer obtained is:
---
$answer
---
Does this answer fully and correctly address the original question?
Reply with EXACTLY one of:
  PASS — if the answer is complete and correct
  FAIL: <improved search query> — if not, provide a better search query after the colon")

    if [[ "$verdict" == PASS* ]]; then
      echo "✅ Verified after $iter iteration(s)." >&2
      break
    fi

    local new_query
    new_query=$(echo "$verdict" | sed 's/^FAIL:[[:space:]]*//')

    if [[ -z "$new_query" || "$new_query" == "$current_query" ]]; then
      echo "⚠️  No improved query suggested, stopping." >&2
      break
    fi

    current_query="$new_query"
    ((iter++))
  done

  if [[ $iter -gt $max_iter ]]; then
    echo "⚠️  Max iterations ($max_iter) reached." >&2
  fi

  echo "$answer"
}

# -----------------------------------------------------------------------------
# kickass — runs all strategies in parallel, Claude picks the best answer
# Usage: kickass "search query"
# -----------------------------------------------------------------------------
kickass() {
  local query="$*"
  if [[ -z "$query" ]]; then
    echo "Usage: kickass <search query>" >&2
    return 1
  fi

  echo "🦵 Running all strategies in parallel for: $query" >&2

  local tmpdir
  tmpdir=$(mktemp -d)

  dumbass "$query" 2>/dev/null > "$tmpdir/dumb" &
  local pid_dumb=$!
  badass "$query" 2>/dev/null > "$tmpdir/bad" &
  local pid_bad=$!
  hardass "$query" 2>/dev/null > "$tmpdir/hard" &
  local pid_hard=$!

  wait $pid_dumb $pid_bad $pid_hard

  echo "🏆 Picking the best answer..." >&2

  local result
  result=$(claude -p "You were asked: \"$query\"
Three different search strategies each produced an answer. Pick the best one and return it, optionally improved by combining insights from the others.

--- DUMBASS (brute-force grep) ---
$(cat "$tmpdir/dumb")

--- BADASS (smart grep) ---
$(cat "$tmpdir/bad")

--- HARDASS (verified grep loop) ---
$(cat "$tmpdir/hard")")

  rm -rf "$tmpdir"
  echo "$result"
}

# -----------------------------------------------------------------------------
# smartass — just ask Claude directly, no grep involved
# Usage: smartass "anything"
# -----------------------------------------------------------------------------
smartass() {
  local query="$*"
  if [[ -z "$query" ]]; then
    echo "Usage: smartass <query>" >&2
    return 1
  fi
  claude -p "$query"
}
