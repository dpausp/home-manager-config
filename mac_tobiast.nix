{ config, pkgs, pkgs-unstable, devenv, lib, ... }:

with builtins;

{
  imports = [
    ./modules/ai.nix
    ./modules/base-common.nix
    ./modules/dev.nix
    ./modules/graphical.nix
    ./modules/mac.nix
    ./modules/nixdev.nix
    ./modules/pin-flakes.nix
    ./modules/pythondev.nix
    ./modules/zsh.nix
  ];

  home = {
    username = "tobiast";
    stateVersion = "24.11"; # Update to the latest version if needed
    homeDirectory = "/Users/tobiast";
  };
}

