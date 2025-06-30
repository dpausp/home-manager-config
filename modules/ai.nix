{ config, pkgs, pkgs-unstable, devenv, lib, ... }:

with builtins;

{
  home.packages = with pkgs-unstable; [
    aider-chat
    ollama
  ];
}
