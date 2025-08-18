{
  ...
}:

{
  programs.zellij = {
    enable = true;
  };

  xdg.configFile."zellij/config.kdl".source = ./config.kdl;

  # Add zellij aliases similar to tmux (ta = "tmux attach")
  programs.zsh = {
    shellAliases = {
      za = "zellij attach";
      zl = "zellij list-sessions";
      zk = "zellij kill-session zellij $SESSION_NAME";
    };

    initContent = ''
      function zssh { ssh -t $1 'zellij attach --create default' }
    '';
  };
}
