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
    git
    git-lfs
    gitAndTools.git-annex
    img2pdf
    jetbrains.pycharm-community
    kubectl
    ngrok
    nix
    pandoc
    pgcli
    sqlitebrowser
    sshfs-fuse
    unison
  ];

  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "ngrok" ];
  };

  programs.feh.enable = true;
  programs.zathura.enable = true;

  programs.zsh = {

    initExtra = ''
      function git-copy-commit-msg {
        commit=''${1:-HEAD}
        git log --format=%B -n1 $commit | pbcopy
      }

      function git-copy-commit-id {
        commit=''${1:-HEAD}
        git rev-parse $commit | tr -d '\n' | pbcopy
      }

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

