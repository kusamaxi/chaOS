# oh my zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="chaos"
zstyle ':omz:update' mode auto      # update automatically without asking
source '/usr/lib/node_modules/@hyperupcall/autoenv/activate.sh'
plugins=(git)
source $ZSH/oh-my-zsh.sh

# autoenv
auto_source_venv() {
  if [[ -d .venv ]]; then
    source .venv/bin/activate
  elif [[ -d venv ]]; then
    source venv/bin/activate
  fi
}
add-zsh-hook chpwd auto_source_venv

# custom
alias vi=nvim
export SSH_AUTH_SOCK=/run/user/1000/ssh-agent.socket
