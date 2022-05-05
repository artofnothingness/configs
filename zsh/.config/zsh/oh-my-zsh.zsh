
export ZSH="/home/$USER/.oh-my-zsh"

# jump
include ~/.autojump/etc/profile.d/autojump.sh
autoload -U compinit && compinit -u

# KEYTIMEOUT=1 # 10ms

plugins=(
  git
  jump
  fzf
  autojump
  ssh-agent

  colorize
  zsh-interactive-cd
  zsh-syntax-highlighting
  zsh-autosuggestions
)
source $ZSH/oh-my-zsh.sh
