{ pkgs, lib, ... }:

with builtins;

{
  home.packages = with pkgs; [
    manix
    niv
    nix-doc
    nix-index
    nix-prefetch
    nix-prefetch-github
    nix-prefetch-scripts
    nix-update
    nixfmt
  ];

}
