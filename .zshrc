# =====================
# Module: History Setup
# =====================
HISTFILE=~/.zsh-histfile
HISTSIZE=200000000
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down


# =====================
# Module: Highlight
# =====================
source ~/.dotfiles/.config/zsh/configs/autosuggestion/zsh-autosuggestions.plugin.zsh

# =====================
# Module: Theme Setup
# =====================
# Uncomment to use the cypher theme
# source ~/.config/zsh/theme/cypher.zsh-theme

# Git prompt theme setup
source ~/.dotfiles/.config/zsh/theme/git-prompt.zsh/git-prompt.zsh
source ~/.dotfiles/.config/zsh/theme/git-prompt.zsh/examples/pure.zsh

# Git prompt theme customizations
DISABLE_UNTRACKED_FILES_DIRTY="true"
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

# =====================
# Module: nvm Setup
# =====================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # Load nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # Load nvm bash_completion

# =====================
# Module: Environment and Tools
# =====================
export PATH="$HOME/.local/bin:$PATH"
eval "$(zoxide init zsh)"

# =====================
# Module: fzf Setup
# =====================
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source <(fzf --zsh)
# =====================
# Module: Aliases
# =====================

