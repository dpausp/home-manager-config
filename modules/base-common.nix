{ config, lib, pkgs, ... }:

with builtins;

let 
  home = config.home.homeDirectory;
in
{
  home.packages = with pkgs; [
    amber
    any-nix-shell
    apg
    bc
    cloc
    delta
    dhall
    diceware
    entr
    fd
    file
    genpass
    graphviz
    hexedit
    html-tidy
    httpie
    inetutils
    ipcalc
    jid
    magic-wormhole
    mailutils
    mosh
    nix-index
    nmap
    remarshal
    ripgrep
    sd
    sharutils
    socat
    sqlite
    sshuttle
    thefuck
    tree
    unzip
    wrk
    zip
  ];

  home.enableNixpkgsReleaseCheck = true;
  home.sessionVariables = { DELTA_PAGER = "bat"; };

  home.shellAliases = { br = "broot"; };

  nixpkgs.overlays = [
    (self: super: {

      vim-myplugin = pkgs.vimUtils.buildVimPlugin { 
        name = "vim-myplugin";
        src = ./vim-myplugin;
      };

      vim-solarized8 = pkgs.vimUtils.buildVimPlugin { 
        name = "vim-solarized8";

        src = pkgs.fetchFromGitHub {
          owner = "lifepillar";
          repo = "vim-solarized8";
          rev = "9f9b7951975012ce51766356c7c28ba56294f9e8";
          sha256 = "XejVHWZe83UUBcp+PyesmBTJdpKBaOnQgN5LcJix6eE=";
        };
      };

      pass-tail = pkgs.stdenv.mkDerivation {
        version = "1.2.0";
        pname = "pass-tail";

        dontBuild = true;
        makeFlags =
          [ "PREFIX=$(out)" "BASHCOMPDIR=$(out)/etc/bash_completion.d" ];

        src = pkgs.fetchFromGitHub {
          owner = "palortoff";
          repo = "pass-extension-tail";
          rev = "784e3e17edd8de4bd3493b75e19165cc5e80c5a0";
          sha256 = "1irxp0jygjb5yn2jjg7hf25b2499d91crznq2yfs3iz0h9dxf8s7";
        };
      };

      genpass = pkgs.writeShellApplication {
        name = "genpass";
        runtimeInputs = with pkgs; [ diceware ];
        text = ''
          for _ in {1..4}; do
            diceware -n8 "$@"
          done
        '';
      };

    })
  ];
  programs.bat.enable = true;
  programs.broot.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.exa.enable = true;
  programs.git = {
    delta.enable = true;
    enable = true;

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

      delta = {
        features = "side-by-side line-numbers decorations";
        navigate = true;
      };

      diff = { colorMoved = "default"; };

      difftool = { prompt = false; };

      fetch = { fsckObjects = true; };

      init = { defaultBranch = "main"; };

      merge = { conflictstyle = "diff3"; };

      "protocol \"http\"" = { allow = "never"; };

      pull = { ff = "only"; };

      rebase = { instructionFormat = "%at <%ae> %s"; };

      transfer = { fsckObjects = true; };

      receive = { fsckObjects = true; };
    };

  };

  programs.htop.enable = true;
  programs.home-manager.enable = true;
  programs.jq.enable = true;
  programs.nix-index.enable = true;

  programs.password-store = {
    enable = true;
    package =
      pkgs.pass.withExtensions (exts: [ exts.pass-genphrase pkgs.pass-tail ]);
    settings = { PASSWORD_STORE_DIR = "${home}/.password-store"; };
  };

  programs.starship.enable = true;

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
    plugins = with pkgs.vimPlugins; [
      neocomplete
      nginx-vim
      unite
      vim-airline
      vim-dirdiff
      vim-jinja
      vim-endwise
      vim-nix
      vim-repeat
      SyntaxRange
      vim-surround
    ] ++ (with pkgs; [
      vim-solarized8
      vim-myplugin
    ]);
  };

  programs.zoxide.enable = true;
}
