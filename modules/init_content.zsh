# disable hosts completion because I use /etc/hosts to block many unwanted sites that would appear as completions without that setting
zstyle ':completion:*:*:*' hosts off

bindkey -M viins '^[.' insert-last-word # Alt-.
bindkey -M vicmd '^[.' insert-last-word # Alt-.

bindkey -M viins '^N' _expand_alias

# Alt-Backspace
bindkey -M viins '^[^?' backward-kill-word
bindkey -M viins '\e\C-h' backward-kill-word

source ~/.keychain/`hostname`-sh &> /dev/null

bindkey -M viins '^f' _navi_widget
bindkey -M vicmd '^f' _navi_widget

# pretty json output with formatting, highlighting (by jq) and line numbers (by bat)
function jat { jq '.' -C < "$1" | bat }

# interactively find a PID from verbose ps output and print it
function fpid { ps aux | fzf -m -q "$@" | awk '{ print $2 }' }

# nix search with json output and jq filtering, can be piped to jid for interactive filtering
function niss {
  search=$1
  shift
  nix search u --json $search | jq "$@"
}

function ssht { ssh -t $1 'tmux attach || tmux -2' }

# run commands via SSH like: RUN="program opt1" zsh
# http://superuser.com/a/790681

eval "$RUN"

export ZAQ_PREFIXES=(
  '[^ ]#pip install( [^ ]##)# -[^ -]#'
  'git commit( [^ ]##)# -[^ -]#m'
  'gcm'
  'gcam'
  'nix-shell( [^ ]##)# --[^ -]#run'
  'lmq'

)
export KEYTIMEOUT=2
source ~/.zshrc.local
