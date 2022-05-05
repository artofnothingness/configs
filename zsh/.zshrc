# General

source $HOME/.config/zsh/env.zsh
source $HOME/.config/zsh/settings.zsh
source $HOME/.config/zsh/oh-my-zsh.zsh
source $HOME/.config/zsh/aliases.zsh

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)
