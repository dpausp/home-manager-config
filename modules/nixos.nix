{ config, pkgs, lib, ... }: {

  home = {
    sessionVariables = {
      CLIPBOARD_COPY_CMD = "xclip";
    };

    shellAliases = {
      # I use systemctl and journalctl all the time, I need convenient aliases :)
      start = "sudo systemctl start";
      stop = "sudo systemctl stop";
      status = "systemctl status";
      restart = "sudo systemctl restart";
      # >S<ystemctl
      s = "sudo systemctl";
      # j>O<urnalctl
      # o is easier to reach than j with Neo2 layout
      o = "journalctl";
      j = "journalctl";
      us = "systemctl --user";
      # other
      m = "mount";
      shm = "cd /dev/shm";
    };
  };

  programs.tmux = {
    extraConfig = ''
      set -g status-right '#(cut -d " " -f 1-4 /proc/loadavg) %H:%M'
    '';
  };

  programs.zsh = {

    shellGlobalAliases = {
      X = "| tr -d '\n' | xclip";
      B = "| bat";
      F = "| fzf";
      V = "| vimr -";
      # From oh-my-zsh common-aliases
      G = "| grep";
      L = "| less";
      NE = "2> /dev/null";
      NUL = "> /dev/null 2>&1";
    };

  };
}
