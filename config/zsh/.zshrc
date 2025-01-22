## Setup highlight
source ~/.dotfiles/config/zsh/configs/highlight/zsh-syntax-highlighting.plugin.zsh
source ~/.dotfiles/config/zsh/configs/autosuggestion/zsh-autosuggestions.plugin.zsh
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
ZSH_THEME_GIT_PROMPT_UPSTREAM_SYMBOL="%{$fg_bold[yellow]%}🔄 "
ZSH_THEME_GIT_PROMPT_UPSTREAM_NO_TRACKING="%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_PREFIX="%{$fg[red]%}(%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SUFFIX="%{$fg[red]%})"
ZSH_THEME_GIT_PROMPT_BEHIND=" ꜛ "
ZSH_THEME_GIT_PROMPT_AHEAD=" ↓ "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%} ╳ "
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%} ✓ "
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%} + "
ZSH_THEME_GIT_PROMPT_UNTRACKED="…" 
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%} 🏳️ " 
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}"
## -- Setup fnm -- 
if type fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --log-level error)"
fi

## -- Setup History
HISTFILE=~/.zsh-histfile
HISTSIZE=200000000
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down
# Aliase

