{ config, pkgs, pkgs-unstable, devenv, lib, ... }:

with builtins;

{
  home.packages = with pkgs-unstable; [
    aider-chat
    llama-cpp
    ollama
  ];

  programs.zsh.shellAliases = {
    aider = "uv run --project ~/git/aider aider";
  };
}
