{
  config,
  pkgs,
  pkgs-unstable,
  devenv,
  lib,
  ...
}:

with builtins;

{
  imports = [
    ./modules/ai.nix
    ./modules/base-common.nix
    ./modules/dev.nix
    ./modules/graphical.nix
    ./modules/mac.nix
    ./modules/neovim
    ./modules/nixdev.nix
    ./modules/pin-flakes.nix
    ./modules/pythondev.nix
    ./modules/zellij
    ./modules/zsh
    ./modules/zsh/standard.nix
  ];

  home = {
    username = "ts";
    stateVersion = "22.05";
    homeDirectory = "/Users/ts";

    packages = with pkgs; [
      moft
    ];
  };

  nixpkgs.overlays = [
    (self: super: {

      moft = pkgs.writeShellApplication {
        name = "moft";
        # Connect with mosh and attach/create zellij default session, like `ssht`
        text = ''
          mosh "$1".fe -- bash -c "zellij attach --create default"
        '';
      };
    })
  ];

  programs.git.settings.safe.directory = "/Users/rovodev/*";

  programs.topgrade = {
    enable = true;
    settings = {

      pre_commands = {
        "Update home manager inputs" = "nix flake update ~";
      };

      commands = {
        "Remove profile versions older than 30d" = "nix profile wipe-history --older-than 7d";
        "Run garbage collection on Nix store" = "nix-collect-garbage";
      };

      misc = {
        assume_yes = true;
        set_title = false;
        cleanup = true;
      };

      disable = [
        "nix"
      ];

      git = {
        repos = [
        ];
        pull_predefined = false;
      };
    };
  };

  programs.zsh = {
    cdpath = [
      "/Users/ts/git"
      "/Users/ts/machines"
      "/Users/ts/venvs"
    ];

    shellAliases = {
      fc-copy-nixpkgs-version = "jq -r '.nixpkgs.rev' < versions.json | tr -d '\n' | pbcopy";
    };
  };
}
