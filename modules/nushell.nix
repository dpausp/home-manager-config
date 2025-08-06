{ config, pkgs, pkgs-unstable, devenv, lib, ... }:
{
  programs.nushell = {
    enable = true;
    package = pkgs-unstable.nushell;
  };
}

