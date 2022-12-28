{ config, pkgs, lib, ... }:

with builtins;

{
  imports = [
    modules/base-common.nix
    modules/graphical.nix
    modules/nixdev.nix
    modules/pythondev.nix
    modules/zsh.nix
  ];

  home.packages = with pkgs; [
    age
    cachix
    cacert
    dmenu
    gawk
    git
    git-lfs
    gitAndTools.git-annex
    img2pdf
    jetbrains.pycharm-community
    kubectl
    moft
    ngrok
    nix
    pandoc
    pgcli
    sqlitebrowser
    sshfs-fuse
    unison
  ];

  home.sessionVariables = {
    EDITOR = "/Users/ts/.nix-profile/bin/vim";
    CLIPBOARD_COPY_CMD = "pbcopy";
  };

  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "ngrok" ];
  };

  nixpkgs.overlays = [
    (self: super: {

      moft = pkgs.writeShellApplication {
        name = "moft";
        # Connect with mosh and attach/create tmux session, like `ssht`
        text = ''
          mosh "$1".fe -- bash -c "tmux attach || tmux"
        '';
      };

    })
  ];
  programs.feh.enable = true;
  programs.zathura.enable = true;

  programs.vim.extraConfig = ''
    vmap <C-c> y:call system("pbcopy", getreg("\""))<CR>
  '';

  programs.zsh = {
    # The Nix init stuff should run as early as possible.
    # Doesn't really matter for the rest.
    initExtra = lib.mkBefore ''
      # Nix
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      # End Nix

      unalias ls
      bindkey -M viins '\e\C-h' backward-kill-word
    '';

    shellAliases = {
      fc-copy-nixpkgs-version = "jq -r '.nixpkgs.rev' < versions.json | tr -d '\n' | pbcopy";
    };

    shellGlobalAliases = {
      X = "| tr -d '\n' | pbcopy";
    };
  };
}

