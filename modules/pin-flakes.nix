{ config, pkgs, nixpkgs, nixpkgs-unstable, home-manager, lib, ... }:

with builtins;

{
  home = {
    activation = {
      nixpkgs = home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
        $DRY_RUN_CMD ln -sfT ${builtins.toString pkgs.path} $HOME/.current-nixpkgs
        $DRY_RUN_CMD rm -rf $HOME/.nix-defexpr
        $DRY_RUN_CMD mkdir -p $HOME/.nix-defexpr/channels
        $DRY_RUN_CMD ln -s ${builtins.toString pkgs.path} $HOME/.nix-defexpr/channels/nixos
      '';
    };
    sessionVariables = {
      NIX_PATH = "nixpkgs=${config.home.homeDirectory}/.current-nixpkgs";
    };
  };

  nix.registry = {
    nixpkgs.flake = nixpkgs;
    n.flake = nixpkgs;
    u.flake = nixpkgs-unstable;
  };
}
