#!/usr/bin/env zsh

PANE_PATH=$(tmux display-message -p -F "#{pane_current_path}")
cd $PANE_PATH

git_status() {
  update_current_git_vars
  echo $(git_super_status)
}

function update_current_git_vars() {
  local gitstatus="$HOME/.oh-my-zsh/plugins/git-prompt/gitstatus.py"

  _GIT_STATUS=$(python ${gitstatus} 2>/dev/null)

  __CURRENT_GIT_STATUS=("${(@s: :)_GIT_STATUS}")
  GIT_BRANCH=$__CURRENT_GIT_STATUS[1]
  GIT_AHEAD=$__CURRENT_GIT_STATUS[2]
  GIT_BEHIND=$__CURRENT_GIT_STATUS[3]
  GIT_STAGED=$__CURRENT_GIT_STATUS[4]
  GIT_CONFLICTS=$__CURRENT_GIT_STATUS[5]
  GIT_CHANGED=$__CURRENT_GIT_STATUS[6]
  GIT_UNTRACKED=$__CURRENT_GIT_STATUS[7]
  GIT_STASHED=$__CURRENT_GIT_STATUS[8]
  GIT_CLEAN=$__CURRENT_GIT_STATUS[9]
}

git_super_status() {
  if [ -n "$__CURRENT_GIT_STATUS" ]; then
    STATUS="#[fg=magenta]⎇ #[bold]$GIT_BRANCH#[none]"
    if [ "$GIT_BEHIND" -ne "0" ]; then
      STATUS="$STATUS ↓ $GIT_BEHIND"
    fi
    if [ "$GIT_AHEAD" -ne "0" ]; then
      STATUS="$STATUS ↑ $GIT_AHEAD"
    fi
    STATUS="$STATUS #[none]|"
    if [ "$GIT_STAGED" -ne "0" ]; then
      STATUS="$STATUS #[fg=red]● $GIT_STAGED"
    fi
    if [ "$GIT_CONFLICTS" -ne "0" ]; then
      STATUS="$STATUS #[fg=red]✖ $GIT_CONFLICTS"
    fi
    if [ "$GIT_CHANGED" -ne "0" ]; then
      STATUS="$STATUS #[fg=blue]✚ $GIT_CHANGED"
    fi
    if [ "$GIT_UNTRACKED" -ne "0" ]; then
      STATUS="$STATUS #[fg=cyan]… $GIT_UNTRACKED"
    fi
    if [ "$GIT_STASHED" -ne "0" ]; then
      STATUS="$STATUS #[fg=blue]⚑ $GIT_STASHED"
    fi
    if [ "$GIT_CLEAN" -eq "1" ]; then
      STATUS="$STATUS #[fg=green]✔"
    fi
    echo "#[fg=colour248,bg=colour235] $STATUS #[bg=default,fg=default]"
  fi
}

git_status
