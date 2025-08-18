{
  ...
}:

with builtins;

{
  imports = [
    ./modules/ai.nix
    ./modules/base-common.nix
    ./modules/dev.nix
    ./modules/graphical.nix
    ./modules/mac.nix
    ./modules/neovim.nix
    ./modules/nixdev.nix
    ./modules/pin-flakes.nix
    ./modules/pythondev.nix
    ./modules/zellij.nix
    ./modules/zsh.nix
  ];

  home = {
    username = "tobiast";
    stateVersion = "24.11"; # Update to the latest version if needed
    homeDirectory = "/Users/tobiast";
  };
}
