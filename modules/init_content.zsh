# disable hosts completion because I use /etc/hosts to block many unwanted sites that would appear as completions without that setting
zstyle ':completion:*:hosts' hosts false

bindkey -M viins '^[.' insert-last-word # Alt-.
bindkey -M vicmd '^[.' insert-last-word # Alt-.

bindkey -M viins '^N' _expand_alias

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


