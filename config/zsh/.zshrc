## Setup highlight
source ~/.dotfiles/config/zsh/configs/highlight/zsh-syntax-highlighting.plugin.zsh
## Setup theme
#source ~/.config/zsh/theme/common.zsh-theme.zsh
source ~/.dotfiles/config/zsh/theme/common-theme.zsh
## Add zshrc
eval "$(zoxide init zsh)"
## FNM
eval "$(fnm env --use-on-cd --shell zsh)"
