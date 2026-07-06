#! @runtimeShell@
set -euo pipefail

if @git@/bin/git diff --cached --quiet; then
  echo 'No staged changes to commit.'
  exit 0
fi

prompt="$(
  echo '$ git diff --cached'
  @git@/bin/git diff --cached --no-ext-diff

  echo '$ git log --oneline -5'
  @git@/bin/git log --oneline -5

  echo 'Generate a commit message from the staged changes and recent commit style, then commit only the currently staged content. Do not modify files, stage additional changes, amend, or push.'
)"

@opencode@/bin/opencode run -m opencode/big-pickle "$prompt"
