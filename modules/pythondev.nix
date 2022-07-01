{ pkgs, lib, ... }:

with builtins;

{
  home.packages = with pkgs.python310Packages; [
    pkgs.python310
    black
    isort
    pkgs.pre-commit
    pip
  ];

}
