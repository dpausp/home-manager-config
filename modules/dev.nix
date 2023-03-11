{ pkgs, lib, devenv, ... }:

with builtins;

{
  home.packages = with pkgs; [
    cloc
    gh
    pre-commit
  ];

}
