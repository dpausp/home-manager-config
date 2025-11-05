{
  config,
  pkgs,
  devenv,
  lib,
  ...
}:

with builtins;

let
  homedir = config.home.homeDirectory;
  unfreePackages = [ ];
  opencode = pkgs.callPackage ../packages/opencode {};
in
{
  home.packages = with pkgs; [
    age
    autossh
    cachix
    cacert
    devenv.packages.aarch64-darwin.devenv
    dmenu
    ffmpeg
    gawk
    git
    git-lfs
    git-annex
    jetbrains.pycharm-community
    kubectl
    nix-output-monitor
    opencode
    pandoc
    pgcli
    procps
    sqlitebrowser
    sshfs-fuse
    uv
    wget
    xonsh
    zoxide
  ];

  home.sessionVariables = {
    CLIPBOARD_COPY_CMD = "pbcopy";
  };

  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ ];
  };

  programs.atuin = {
    enable = true;
    flags = [
      "--disable-up-arrow"
    ];
  };

  programs.feh.enable = true;

  programs.fish = {
    enable = true;
  };

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
  };

  programs.tmux.extraConfig = ''
    set -g status-right '%H:%M'
    set -g default-command "${homedir}/.nix-profile/bin/zsh"
  '';

  programs.vim.extraConfig = ''
    vmap <C-c> y:call system("pbcopy", getreg("\""))<CR>
  '';

  programs.wezterm = {
    enable = true;
  };

  programs.zathura.enable = true;

  programs.zsh = {
    cdpath = [
      "${homedir}/git"
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
      hc = "cd ~/git/hm-config";
      copy = "pbcopy < ";
    };

    shellGlobalAliases = {
      X = "| tr -d '\n' | pbcopy";
    };
  };
}
