{
  config,
  pkgs,
  lib,
  ...
}:

with builtins;

{
  imports = [
    modules/base-common.nix
    modules/dev.nix
    modules/mac.nix
    modules/neovim
    modules/nixdev.nix
    modules/pin-flakes.nix
    modules/pythondev.nix
    modules/zsh
    modules/zsh/smol.nix
  ];

  home = {
    username = "rovodev";
    stateVersion = "25.05";
    homeDirectory = "/Users/rovodev";
  };

  programs.zsh = {
  };
}
