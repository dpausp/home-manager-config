{ config, pkgs, lib, ... }: {

  programs.zsh = {

    oh-my-zsh = {
      plugins = [ "systemd" ];
    };

    shellAliases = {
      # systemd
      sc = "systemctl";
      jc = "journalctl";
      usc = "systemctl --user";

      # other
      m = "mount";
      shm = "cd /dev/shm";
    };

    shellGlobalAliases = {
      X = "| tr -d '\n' | xclip";
    };

  };
}
