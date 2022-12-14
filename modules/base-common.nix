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
    git-filter-repo
    gnupg
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
    netcat-gnu
    mtr
    nix-index
    nmap
    pssh
    remarshal
    rich-cli
    ripgrep
    sd
    sharutils
    shellcheck
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
  home.sessionVariables = {
    DELTA_PAGER = "bat";
    LC_MESSAGES = "C";
    EDITOR = "vim";
  };

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
  programs.fzf.enable = true;
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

    ignores = [
      ".dbeaver-data-sources.xml"
      ".idea"
      ".in-syncrc"
      ".out-syncrc"
      ".project"
      ".pydevproject"
      ".runrc"
      ".settings"
      ".vscode"
    ];

  };

  programs.htop.enable = true;
  programs.home-manager.enable = true;
  programs.jq.enable = true;
  programs.navi.enable = true;
  programs.nix-index.enable = true;

  programs.password-store = {
    enable = true;
    package =
      pkgs.pass.withExtensions (exts: [ exts.pass-genphrase pkgs.pass-tail ]);
    settings = { PASSWORD_STORE_DIR = "${home}/.password-store"; };
  };

  programs.starship = {
    enable = true;
    settings = {
      status = {
        disabled = false;
        format = "$status [$symbol$common_meaning$signal_name]($style) ";
      };
    };
  };
  programs.tealdeer.enable = true;

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
      vim-indent-object
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

  programs.zsh = {

    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;

    oh-my-zsh = {
      plugins = [ "git" "dirhistory" "vi-mode" ];
    };

    shellAliases = {
      # annex
      x = "git annex";
      # git
      gita = "git add";
      # add changes, ignore whitespace
      gitaww = "git diff -w --no-color | git apply --cached --ignore-whitespace";
      gitb = "git bisect";
      gitc = "git commit";
      gitd = "git diff";
      gitdc = "git diff --cached";
      gitl = "git log";
      gitls = "git log --pretty=format:'%H %as %s (%an)'";
      gitp = "git push";
      gits = "git status";
      # Nix
      hm = "home-manager";
      nis = "nix search u";
      # other
      br = "broot";
      debug = "zsh .debugrc";
      dum = "du -m --max-depth=1";
      fu = "fuck";
      la = "exa -la";
      ll = "exa -l";
      ls = "ls --color";
      newest_file = "ls -1t | head -n1";
      pstat = "python -mpstats";
      py = "python";
      run = "zsh .runrc";
      svi = "sudo -E vim";
      tj = "tar xjf";
      tl = "tldr";
      tz = "tar xzf";
      vi = "vim";
    };

    plugins = [
      {
        # Auto-quote arguments for commands matching ZAQ_PREFIXES
        name = "zsh-autoquoter";
        src = pkgs.fetchFromGitHub {
          owner = "ianthehenry";
          repo = "zsh-autoquoter";
          rev = "819a615fbfd2ad25c5d311080e3a325696b45de7";
          sha256 = "r0jdo+YFTOejvNMTqzXi5ftcLzDpuKejX0wMFwqKdJY=";
        };
      }
      {
        # Search the current line instead of history using / and ?
        name = "zsh-vi-search";
        file = "src/zsh-vi-search.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "soheilpro";
          repo = "zsh-vi-search";
          rev = "445c8a27dd2ce315176f18b4c7213c848f215675";
          sha256 = "ddqUEN6YebrVtT8Ae0ssWt2xlYxRhW5H3uRY0PoksoM=";
        };
      }
    ];

    sessionVariables = {
      VI_MODE_SET_CURSOR = true;
    };

    shellGlobalAliases = {
      F = "| fzf";
    };

    initExtra = ''
      # init any-nix-shell manually, would be nice for home manager integration
      any-nix-shell zsh --info-right | source /dev/stdin

      # Inlined output of `fuck --alias fu`
      # thefuck recommends evaling the command here but it's fucking slow :)

      fuck () {
          TF_PYTHONIOENCODING=$PYTHONIOENCODING;
          export TF_SHELL=zsh;
          export TF_ALIAS=fuck;
          TF_SHELL_ALIASES=$(alias);
          export TF_SHELL_ALIASES;
          TF_HISTORY="$(fc -ln -10)";
          export TF_HISTORY;
          export PYTHONIOENCODING=utf-8;
          TF_CMD=$(
              thefuck THEFUCK_ARGUMENT_PLACEHOLDER $@
          ) && eval $TF_CMD;
          unset TF_HISTORY;
          export PYTHONIOENCODING=$TF_PYTHONIOENCODING;
          test -n "$TF_CMD" && print -s $TF_CMD
      }

      # disable hosts completion because I use /etc/hosts to block many unwanted sites that would appear as completions without that setting
      zstyle ':completion:*:*:*' hosts off

      bindkey -M viins '^[.' insert-last-word # Alt-.
      bindkey -M vicmd '^[.' insert-last-word # Alt-.

      bindkey -M viins '^[^?' backward-kill-word # Alt-Backspace

      source ~/.keychain/`hostname`-sh &> /dev/null

      function git-push-branch {
        git push -u origin $(git rev-parse --abbrev-ref HEAD)
      }

      # pretty json output with formatting, highlighting (by jq) and line numbers (by bat)
      function jat { jq '.' -C < "$1" | bat }

      # interactively find a PID from verbose ps output and print it
      function fpid { ps aux | fzf -m -q "$@" | awk '{ print $2 }' }

      # nix search with json output and jq filtering, can be piped to jid for interactive filtering
      function niss() {
        search=$1
        shift
        nix search u --json $search | jq "$@"
      }

      rwhich() {
          WHICH=`which $1`
          if [[ $? == 0 ]] then
              readlink -f $WHICH
          else
              echo $WHICH
          fi
      }

      nish() {
          nix-shell -p "$@" --run zsh
      }

      out() {
          zsh .out-syncrc "$@"
      }

      in() {
          zsh .in-syncrc "$@"
      }

      ssht () { ssh -t $1 'tmux attach || tmux' }

      eval "$(direnv hook zsh)"

      # Broken with home-manager zsh config
      # "spams grep: command not found"
      # TRAPHUP() {
      #   print "Caught HUP, reloading zsh"
      #   . ~/.zshrc
      # }

      # run commands via SSH like: RUN="program opt1" zsh
      # http://superuser.com/a/790681
      eval "$RUN"

      export ZAQ_PREFIXES=(
        '[^ ]#pip install( [^ ]##)# -[^ -]#'
        'gitc( [^ ]##)# -[^ -]#m'
        'nix-shell( [^ ]##)# --[^ -]#run'
        'ssh( [^ ]##)# [^ -][^ ]#'
      )
    '';
  };

  xdg.configFile."thefuck/settings.py".text = ''
    # fuck often makes nonsensical recommendations with files from the nix
    # store instead of just fixing the command (giit tag, for example).
    priority = {"fix_file": 9999}
  '';
}
