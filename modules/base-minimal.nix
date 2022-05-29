{ pkgs, lib, ... }:

with builtins;

{
  home.packages = with pkgs; [
    any-nix-shell
    entr
    fd
    file
    ripgrep
    sd
    tree
    unzip
  ];

  home.enableNixpkgsReleaseCheck = true;
  home.sessionVariables = { DELTA_PAGER = "bat"; };

  programs.bat.enable = true;
  programs.exa.enable = true;
  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;

    userName = "Tobias dpausp";
    userEmail = "dpausp@posteo.de";

    aliases = {
      co = "checkout";
      re = "rebase";
      id = "rev-parse HEAD";
      br =
        "for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'";
    };

    extraConfig = {

      color = {
        ui = true;
        log = true;
        status = true;
        pull = true;
        fetch = true;
        push = true;
        interactive = true;
      };

      diff = { colorMoved = "default"; };

      difftool = { prompt = false; };

      fetch = { fsckObjects = true; };

      merge = { conflictstyle = "diff3"; };

      "protocol \"http\"" = { allow = "never"; };

      pull = { ff = "only"; };

      rebase = { instructionFormat = "%at <%ae> %s"; };

      transfer = { fsckObjects = true; };

      receive = { fsckObjects = true; };
    };

  };

  programs.home-manager.enable = true;

  programs.tmux = {
    baseIndex = 1;
    clock24 = true;
    enable = true;
    escapeTime = 1;
    extraConfig = readFile ./tmuxrc;
    historyLimit = 50000;
    keyMode = "vi";
    newSession = true;
    terminal = "screen-256color";
  };

  programs.vim = {
    enable = true;
    packageConfigurable = lib.mkDefault (pkgs.vimUtils.makeCustomizable
      (pkgs.vim_configurable.override {
        config = {
          netbeans = false;
          vim = { gui = "no"; };
        };
        libX11 = null;
        libXext = null;
        libSM = null;
        libXpm = null;
        libXt = null;
        libXaw = null;
        libXau = null;
        libXmu = null;
        libICE = null;
        gtk2-x11 = null;
        gtk3-x11 = null;
      }));

    extraConfig = readFile ./vimrc;
    plugins = with pkgs.vimPlugins; [ vim-airline vim-nix vim-surround ];
  };

  programs.zoxide.enable = true;
}
