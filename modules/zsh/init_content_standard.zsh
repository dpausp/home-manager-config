# disable hosts completion because I use /etc/hosts to block many unwanted sites that would appear as completions without that setting
zstyle ':completion:*:hosts' hosts false

# tab-completion for aliases
# https://superuser.com/questions/1514569/how-to-expand-aliases-inline-in-zsh
zstyle ':completion:*' completer _expand_alias _complete _ignored

bindkey '^[.' insert-last-word # Alt-.

bindkey -M viins "^[f" forward-word
bindkey -M viins "^[b" backward-word

# Alt-Backspace
bindkey -M viins '^[^?' backward-kill-word
bindkey -M viins '\e\C-h' backward-kill-word

# Navi widget to Alt-F to not interfere with default zellij ALT-G
bindkey -M viins '^f' _navi_widget
bindkey -M vicmd '^f' _navi_widget

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

# run commands via SSH like: RUN="program opt1" zsh
# http://superuser.com/a/790681
eval "$RUN"


