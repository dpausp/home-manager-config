{ config, pkgs, lib, ... }:

{
  imports = [
    ./modules/neovim
  ];

  home = {
    username = "rovodev";
    stateVersion = "25.05";
    homeDirectory = "/Users/rovodev";
  };

  # Minimal packages for testing
  home.packages = with pkgs; [
    git
    ripgrep
    jq
    nodePackages.vscode-langservers-extracted
    nodePackages.prettier
  ];

  programs.home-manager.enable = true;
  programs.git.enable = true;
}