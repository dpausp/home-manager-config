{ config, pkgs, pkgs-unstable, lib, ... }:

with builtins;

let
  mkNixpkgsFlakeShim = flake: pkgs.writeText "nixpkgs-from-flake" ''
    _ : (builtins.getFlake "${flake}").outputs.legacyPackages.''${builtins.currentSystem}
  '';
in
{

  imports = [
    modules/base-common.nix
    modules/graphical.nix
    modules/nixdev.nix
    modules/nixos-x11.nix
    modules/nixos.nix
    modules/pythondev.nix
    modules/zsh.nix
  ];

  home.packages = with pkgs; [
    abcde
    akonadi
    amarok
    cachix
    cawbird
    chromium
    clearlooks-phenix
    digikam
    dmenu
    fileschanged
    fira-code
    fira-mono
    gajim
    geeqie
    gimp
    git
    gitAndTools.git-annex
    gitAndTools.qgit
    gtk_engines
    img2pdf
    jetbrains.pycharm-community
    keychain
    kontact
    korganizer
    kubectl
    kwalletmanager
    libreoffice
    mimeo
    ngrok
    pkgs-unstable.nix
    okular
    pandoc
    pdftk
    pgcli
    pinentry-curses
    plasma5Packages.bismuth
    simple-scan
    simplescreenrecorder
    spectacle
    sqlitebrowser
    sshfs-fuse
    sublime4
    thunderbird
    unison
    vlc
    wireshark
    xclip
    xdg-user-dirs
    xsane
    yt-dlp
    zeal
  ];

  home.sessionPath = [ "/home/ts/.local/bin" ];

  manual.html.enable = true;
  manual.json.enable = true;
  manual.manpages.enable = true;

  nix.package = pkgs-unstable.nix;

  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "ngrok" "sublimetext4" ];
  };

  programs.chromium.enable = true;
  programs.feh.enable = true;
  programs.firefox.enable = true;

  programs.git = {
    userName = "Tobias dpausp";
    userEmail = "dpausp@posteo.de";

    extraConfig = {
      safe = { directory = "/home/ts/annex/belakor"; };
    };
  };

  programs.gpg.enable = true;
  # XXX: needs config
  programs.keychain.enable = false;
  programs.mpv.enable = true;
  programs.noti.enable = true;
  programs.taskwarrior.enable = true;

  programs.texlive.enable = true;
  programs.topgrade.enable = true;
  programs.topgrade.settings = {
    disable = [ "system" "tmux" "vim" "pip3" "home_manager" ];
    pre_commands = {
      "Update pinned nixpkgs for nixops" = "(cd ~/nixos-machines-home && niv update)";
      "nixos deploy local system (vader)" =
        "nix-shell ~/nixos-machines-home --run 'nixops deploy -d home --include vader'";
      "Update home manager inputs" = "nix flake update ~/.config/nixpkgs";
      "Update pinned stable nixpkgs (n)" =
        "nix registry pin n github:nixos/nixpkgs/nixos-22.05";
      "Update pinned unstable nixpkgs (u)" =
        "nix registry pin u github:nixos/nixpkgs/nixos-unstable";
    };
    commands = {
      # topgrade supports home-manager, but home-manager switch is broken with newer Nix versions.
      # Replacing the current profile entry fails sometimes.
      # Build the home config, remove the old config, and activate the new one manually instead.
      "Build home-manager config" =
        "(cd ~/.config/nixpkgs && home-manager build && nix profile remove 0 && result/activate)";
      "Run garbage collection on Nix store" = "sudo nix-collect-garbage";
      "Remove profile versions older than 30d" =
        "nix profile wipe-history --older-than 30d";
    };
  };

  programs.vscode.enable = false;
  programs.vscode.package = pkgs.vscodium;
  programs.zathura.enable = true;

  programs.zsh = {
    shellAliases = {
      xs = "git push belakor master";
    };

    envExtra = ''
      setopt no_global_rcs
      # Sync old-style tools using NIX_PATH with the flake view.
      # For example, `nix-shell -p python310` will run what
      # `nix search n#python310` shows.
      # This references the independently managed `n` and `u` flakes.
      # For now, I want to keep it separate but it's also possible
      # to sync the NIX_PATH with the home-manager inputs similar to:
      # https://gitlab.univ-rouen.fr/sreycoyrehourcq/dotfiles/-/blob/f1f8624c14920407c39bbeeb0e4c0397ea25e980/nixos-config.nix#L71
      export NIX_PATH="nixpkgs=${mkNixpkgsFlakeShim "n"}:nixpkgs-unstable=${mkNixpkgsFlakeShim "u"}";
    '';

    initExtra = ''
      function xg {
        git annex get "$@"
        git annex copy --to belakor "$@"
      }
    '';
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 86400;
    pinentryFlavor = "curses";
  };
  services.kdeconnect.enable = true;
  services.lorri.enable = true;

}

