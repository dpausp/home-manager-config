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
  home.packages = with pkgs-unstable; [
    ollama
  ];

  programs.zsh.shellAliases = {
  };
}
