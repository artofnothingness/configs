
export ZSH="/home/$USER/.oh-my-zsh"

# jump
include ~/.autojump/etc/profile.d/autojump.sh
autoload -U compinit && compinit -u

#vi-mode
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
bindkey -v
# KEYTIMEOUT=1 # 10ms

plugins=(
  git
  jump
  fzf
  autojump
  vi-mode
  ssh-agent

  colorize
  zsh-interactive-cd
  zsh-syntax-highlighting
  zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh
