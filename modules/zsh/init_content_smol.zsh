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
  'git commit( [^ ]##)# -[^ -]#m'
  'gcm'
  'gcam'
  'nix-shell( [^ ]##)# --[^ -]#run'
  'r'
  'rn'
)

export KEYTIMEOUT=2
source ~/.zshrc.local



