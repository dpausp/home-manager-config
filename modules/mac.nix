{ config, pkgs, pkgs-unstable, devenv, lib, ... }:

with builtins;

let
  homedir = config.home.homeDirectory;
  unfreePackages = [];
in
{
  home.packages = with pkgs; [
    age
    cachix
    cacert
    devenv.packages.aarch64-darwin.devenv
    dmenu
    gawk
    git
    git-lfs
    gitAndTools.git-annex
    jetbrains.pycharm-community
    kubectl
    nix-output-monitor
    pandoc
    pgcli
    procps
    sqlitebrowser
    sshfs-fuse
    topgrade
    uv
    wget
    zoxide
  ];

  home.sessionVariables = {
    CLIPBOARD_COPY_CMD = "pbcopy";
  };

  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ ];
  };

  programs.atuin = {
    enable = true;
    flags = [
      "--disable-up-arrow"
    ];
    package = pkgs-unstable.atuin;
  };

  programs.feh.enable = true;

  programs.nushell = {
    enable = true;
    package = pkgs-unstable.nushell;
    configFile.source = ./config.nu;
  };

  programs.fish = {
    enable = true;
  };

  programs.tmux.extraConfig = ''
    set -g status-right '%H:%M'
    set -g default-command "${homedir}/.nix-profile/bin/zsh"
  '';

  programs.vim.extraConfig = ''
    vmap <C-c> y:call system("pbcopy", getreg("\""))<CR>
  '';

  programs.zathura.enable = true;

  programs.zsh = {
    cdpath = [
      "${homedir}/git"
      "${homedir}/machines"
      "${homedir}/venvs"
    ];
    # The Nix init stuff should run as early as possible.
    # Doesn't really matter for the rest.
    initContent = lib.mkBefore ''
      # Nix
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      # End Nix

      bindkey -M viins '\e\C-h' backward-kill-word
    '';

    shellAliases = {
      esc = "open -t ~/.ssh/config";
      fc-copy-nixpkgs-version = "jq -r '.nixpkgs.rev' < versions.json | tr -d '\n' | pbcopy";
      ot = "open -t";
      up = "home-manager switch";
      hc = "cd ~/.config/home-manager";
    };

    shellGlobalAliases = {
      X = "| tr -d '\n' | pbcopy";
    };
  };
}

