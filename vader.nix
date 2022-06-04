{ config, pkgs, lib, ... }:

with builtins;

{

  imports = [
    modules/base-common.nix
    modules/graphical.nix
    modules/nixdev.nix
    modules/nixos.nix
    modules/pythondev.nix
    modules/zsh.nix
  ];

  home.packages = with pkgs; [
    abcde
    akonadi
    amarok
    cachix
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
    ngrok
    okular
    pandoc
    pdftk
    pgcli
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
    youtube-dl
    zeal
  ];

  home.sessionPath = [ "/home/ts/.local/bin" ];

  manual.html.enable = true;
  manual.json.enable = true;
  manual.manpages.enable = true;

  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "ngrok" "sublimetext4" ];
  };

  programs.browserpass.enable = true;
  programs.chromium.enable = true;
  programs.feh.enable = true;
  programs.firefox.enable = true;

  programs.git = {
    extraConfig = {
      safe = { directory = "/home/ts/annex/belakor"; };
    };
  };

  programs.gpg.enable = true;
  # XXX: needs config
  programs.keychain.enable = false;
  programs.mpv.enable = true;
  programs.noti.enable = true;
  programs.qutebrowser = {
    enable = false;

    extraConfig = let
      passCmd =
        "spawn --userscript qute-pass-custom -d dmenu -U secret -u '^user: (.+)'";
    in ''
      config.bind("aa", "${passCmd}", mode="normal")
      config.bind("<Ctrl+s>", "${passCmd}", mode="insert")

      c.url.searchengines = {
          "DEFAULT": "https://www.startpage.com/do/search?query={}",
          "ddg": "https://duckduckgo.com/?q={}",
          "py": "https://docs.python.org/3.10/search.html?q={}",
          "pyl": "https://docs.python.org/3.10/library/{}.html",
          "pypi": "https://pypi.org/search/?q={}",
          "sp": "https://www.startpage.com/do/search?query={}",
          "np": "https://mynixos.com/search?q=package+{}",
          "n": "https://mynixos.com/search?q={}",
      }

    '';

    settings = {

      editor.command = ''
        ["konsole", "-e", "vim", "{file}", "-c", "normal {line}G{column0}l"]'';
      colors.webpage.bg = "grey";
      tabs.background = true;
      tabs.new_position.unrelated = "last";

    };
  };

  programs.taskwarrior.enable = true;

  programs.texlive.enable = true;
  programs.topgrade.enable = true;
  programs.topgrade.settings = {
    disable = [ "system" "tmux" "vim" "pip3" ];
    pre_commands = {
      "Update pinned nixpkgs for nixops" = "(cd ~/nixos-machines-home && niv update)";
      "nixos deploy local system (vader)" =
        "nix-shell ~/nixos-machines-home/shell.nix --run 'nixops deploy -d home --include vader'";
      "Update home manager inputs" = "nix flake update ~/.config/nixpkgs";
      "Update pinned stable nixpkgs (n)" =
        "nix registry pin n github:nixos/nixpkgs/nixos-22.05";
      "Update pinned unstable nixpkgs (u)" =
        "nix registry pin u github:nixos/nixpkgs/nixos-unstable";
    };
    commands = {
      "Upgrade profile" = "nix profile upgrade";
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
  };

  services.lorri.enable = true;

}

