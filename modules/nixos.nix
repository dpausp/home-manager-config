{ config, pkgs, lib, ... }: {

  programs.zsh = {

    initExtra = ''
      function git-copy-commit-id {
        commit=''${1:-HEAD}
        git rev-parse $commit | tr -d '\n' | xclip
      }

      function git-copy-commit-msg {
        commit=''${1:-HEAD}
        git log --format=%B -n1 $commit | xclip
      }
    '';

    oh-my-zsh = {
      plugins = [ "systemd" ];
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

    shellGlobalAliases = {
      X = "| tr -d '\n' | xclip";
    };

  };
}
