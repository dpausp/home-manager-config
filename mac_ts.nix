{ config, pkgs, pkgs-unstable, devenv, lib, ... }:

with builtins;

{
  imports = [
    modules/ai.nix
    modules/base-common.nix
    modules/dev.nix
    modules/graphical.nix
    modules/mac.nix
    modules/nixdev.nix
    modules/pin-flakes.nix
    modules/pythondev.nix
    modules/zsh.nix
  ];

  home = {
    username = "ts";
    stateVersion = "22.05";
    homeDirectory = "/Users/ts";

    packages = with pkgs; [
      moft
    ];
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

  programs.zsh = {
    cdpath = [
      "/Users/ts/git"
      "/Users/ts/machines"
      "/Users/ts/venvs"
    ];

    shellAliases = {
      fc-copy-nixpkgs-version = "jq -r '.nixpkgs.rev' < versions.json | tr -d '\n' | pbcopy";
    };
  };
}

