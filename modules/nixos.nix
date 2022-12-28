{ config, pkgs, lib, ... }: {

  home.sessionVariables = {
    CLIPBOARD_COPY_CMD = "xclip";
  };


  programs.zsh = {

    initExtra = ''
      function hms {
        (cd ~/.config/nixpkgs && home-manager build && nix profile remove 0 && result/activate)
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
