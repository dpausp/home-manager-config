{
  config,
  pkgs,
  pkgs-unstable,
  devenv,
  lib,
  ...
}:

with builtins;

{
  imports = [
    modules/ai.nix
    modules/base-common.nix
    modules/dev.nix
    modules/mac.nix
    modules/neovim.nix
    modules/nixdev.nix
    modules/pin-flakes.nix
    modules/pythondev.nix
    modules/zellij.nix
    modules/zsh.nix
  ];

  home = {
    username = "rovodev";
    stateVersion = "25.05";
    homeDirectory = "/Users/rovodev";
  };

  nixpkgs.overlays = [
    (self: super: {
    })
  ];

  programs.zsh = {
  };
}
