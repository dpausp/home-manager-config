{ pkgs, lib, ... }:

with builtins;

{
  home.packages = with pkgs; [
    any-nix-shell
    niv
    nix-index
    nix-prefetch
    nix-prefetch-github
    nix-prefetch-scripts
    nix-update
    nixfmt
  ];

}
