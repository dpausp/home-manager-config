{ config, pkgs, lib, ... }:

{
  imports = [
    ./modules/neovim
  ];

  home = {
    username = builtins.getEnv "USER";
    stateVersion = "25.05";
    homeDirectory = builtins.getEnv "HOME";
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

  # Enable flakes for this config
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };
}