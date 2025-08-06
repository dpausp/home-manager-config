{
  config,
  pkgs,
  lib,
  ...
}:
{

  home = {
    sessionVariables = {
      CLIPBOARD_COPY_CMD = "xclip";
    };

    shellAliases = rec {
      j = "journalctl";
      o = "journalctl"; # j>O<urnalctl
      restart = "sudo systemctl restart";
      re = "sudo systemctl restart";
      run = "zsh .runrc";
      s = "systemctl status --no-pager";
      sc = "systemctl cat --no-pager";
      sf = "systemctl --failed --no-pager";
      sj = "systemctl list-jobs --no-pager";
      sl = "sudo systemctl";
      st = start;
      sti = "systemctl list-timers --no-pager";
      start = "sudo systemctl start";
      status = "systemctl status";
      stop = "sudo systemctl stop";
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
    };

  };
}
