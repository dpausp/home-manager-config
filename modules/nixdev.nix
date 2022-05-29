{ pkgs, lib, ... }:

with builtins;

{
  home.packages = with pkgs; [
    any-nix-shell
    nix-index
    nix-prefetch-github
    nix-prefetch-scripts
    nixfmt
    nix-update
    niv
  ];

}
