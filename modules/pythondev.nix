{ pkgs, lib, ... }:

with builtins;

{
  home.packages = with pkgs.python310Packages; [
    pkgs.python39
    (pkgs.python310.overrideAttrs (_: { meta.priority = 3; }) )
    black
    isort
    pkgs.pre-commit
    pip
  ];

}
