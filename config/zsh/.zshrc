## Setup highlight
# source ~/.dotfiles/config/zsh/configs/highlight/zsh-syntax-highlighting.plugin.zsh
## Setup theme
#source ~/.config/zsh/theme/cypher.zsh-theme
 source ~/.dotfiles/config/zsh/theme/git-prompt.zsh/git-prompt.zsh
 source ~/.dotfiles/config/zsh/theme/git-prompt.zsh/examples/pure.zsh
## Add zshrc
#
 eval "$(zoxide init zsh)"
## FNM
 eval "$(fnm env --use-on-cd --shell zsh)"
## FZF
 source <(fzf --zsh)

## Tweak
DISABLE_UNTRACKED_FILES_DIRTY="true"
### Themes
ZSH_THEME_GIT_PROMPT_PREFIX="["
ZSH_THEME_GIT_PROMPT_SUFFIX="] "
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_DETACHED="%{$fg_bold[cyan]%}:"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SYMBOL="%{$fg_bold[yellow]%}🔄 " # Emoji thay cho ⟳
ZSH_THEME_GIT_PROMPT_UPSTREAM_NO_TRACKING="%{$fg_bold[red]%} ! " # Emoji thay cho !
ZSH_THEME_GIT_PROMPT_UPSTREAM_PREFIX="%{$fg[red]%}(%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SUFFIX="%{$fg[red]%})"
ZSH_THEME_GIT_PROMPT_BEHIND=" ꜛ " # Emoji thay cho ↓
ZSH_THEME_GIT_PROMPT_AHEAD=" ↓ " # Emoji thay cho ↑
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%} ╳ " # Emoji thay cho ✖
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%} ✓ " # Emoji thay cho ●
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%} + " # Emoji thay cho ✚
ZSH_THEME_GIT_PROMPT_UNTRACKED="…" # Giữ nguyên nếu không cần thay đổi
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%} 🏳️ " # Emoji thay cho ⚑
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✔️" # Emoji thay cho ✔


if type fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --log-level error)"
fi
