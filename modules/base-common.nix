{ config, lib, pkgs, pkgs-unstable, ... }:

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
    dbat
    delta
    dhall
    diceware
    dvimr
    entr
    fd
    file
    findUpCmd
    fpp
    genpass
    git-filter-repo
    git-push-branch
    glances
    gnupg
    graphviz
    hexedit
    html-tidy
    httpie
    inCmd
    inetutils
    ipcalc
    jid
    lnav
    (lnavGit.overrideAttrs (_: { meta.priority = 10; }) )
    magic-wormhole
    mailutils
    mosh
    nagelfar
    netcat-gnu
    mtr
    nix-index
    nmap
    nvd
    outCmd
    pipe-rename
    pssh
    remarshal
    rich-cli
    ripgrep
    rwhich
    sd
    sharutils
    shellcheck
    socat
    sqlite
    sshuttle
    tailscale
    thefuck
    thumbs
    tree
    unzip
    vimr
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
      inherit (pkgs-unstable) delta lnav;

      lnavGit =
        let rev = "a49c37e0af4392d6dd78b03efb5e78bcbeebc744";
        in pkgs-unstable.lnav.overrideAttrs (old: {
          version = "2025-06-05-${builtins.substring 0 7 rev}";
          name = "lnav-unstable";
          src = pkgs.fetchFromGitHub {
            owner = "tstack";
            repo = "lnav";
            inherit rev;
            hash = "sha256-CSt33LfKwhV6fzEuRI3t/2avkMfBAsrCgw75cbJ5gqM=";
          };
          patches = [];
        });

      # Update to a version that has tmux_osc52 support and remove xclip dep.
      tmuxPlugins = super.tmuxPlugins // {
        extrakto = super.tmuxPlugins.extrakto.overrideAttrs (old: {
          name = "tmuxplugin-extrakto-unstable-2022-11-03";
          version = "unstable-2022-11-03";
          src = pkgs.fetchFromGitHub {
            owner = "laktak";
            repo = "extrakto";
            rev = "4179acea28f69853fda9ab15c7564cd73757856c";
            sha256 = "BfQkVxVwT+hjb2T13H1EPKXS+W5FIJyQkR+Iz9079FU=";
          };
          postInstall = ''
          for f in extrakto.sh open.sh; do
            wrapProgram $target/scripts/$f \
              --prefix PATH : ${with pkgs; lib.makeBinPath (
              [ pkgs.fzf pkgs.python3 ]
              )}
          done
          '';
        });

        sensible = super.tmuxPlugins.sensible.overrideAttrs (old: {
          name = "tmuxplugin-sensible-unstable-2022-08-14";
          version = "unstable-2022-08-14";
          src = pkgs.fetchFromGitHub {
            owner = "tmux-plugins";
            repo = "tmux-sensible";
            rev = "25cb91f42d020f675bb0a2ce3fbd3a5d96119efa";
            sha256 = "sw9g1Yzmv2fdZFLJSGhx1tatQ+TtjDYNZI5uny0+5Hg=";
          };
        });
      };

      dbat = pkgs.writeShellApplication {
        name = "dbat";
        text = ''
          bat "$(nix path-info "$@")"
        '';
      };

      dvimr = pkgs.writeShellApplication {
        name = "dvimr";
        text = ''
          if [[ $# -eq 0 ]]; then exit 1; fi
          vr "$(nix path-info "$@")"
        '';
      };

      findUpCmd = pkgs.writeTclApplication {
        name = "find_up";
        text = ''
          set curpath [pwd]
          set file [lindex $argv 0]

          while { $curpath != "/" } {
              if { [file exists "$curpath/$file"] } {
                  puts "$curpath/$file"
                  exit 0
              }
              set curpath [file dirname $curpath]
          }

          puts stderr "Error: file '$file' not found in current and parent dirs!"
          exit 2
        '';
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

      git-push-branch = pkgs.writeShellApplication {
        name = "git-push-branch";
        text = ''
          git push -u origin "$(git rev-parse --abbrev-ref HEAD)"
        '';
      };

      inCmd = pkgs.writeShellApplication {
        name = "in";
        text = ''
          rcfile=$(find_up .in-syncrc)
          echo ----
          echo "Executing $rcfile"
          bat -pp "$rcfile"
          if [[ $# -gt 0 ]]; then
            echo "args: $*"
          fi
          echo -------- start
          sh "$rcfile" "$@"
          echo ---------------- end
        '';
      };

      nagelfar = super.nagelfar.overrideAttrs(prev: {
        installPhase = prev.installPhase + ''
          mkdir $out/lib
          cp $src/syntax*.tcl $out/lib/
        '';
      });

      nir = pkgs.writeShellApplication {
        name = "nir";
        text = ''
          nix run nixpkgs#"$1"
        '';
      };

      outCmd = pkgs.writeShellApplication {
        name = "out";
        text = ''
          rcfile=$(find_up .out-syncrc)
          echo ----
          echo "Executing $rcfile"
          bat -pp "$rcfile"
          if [[ $# -gt 0 ]]; then
            echo "args: $*"
          fi
          echo -------- start
          sh "$rcfile" "$@"
          echo ---------------- end
        '';
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

      rwhich = pkgs.writeTclApplication {
        name = "rwhich";
        text = ''
          set program [lindex $argv 0]
          if { [catch { exec which $program } result] } {
              puts "$program not found"
          } else {
              puts [exec readlink -f $result]
          }
        '';
      };

      vim-myplugin = pkgs.vimUtils.buildVimPlugin {
        name = "vim-myplugin";
        src = ./vim-myplugin;
      };

      vimr = pkgs.writeShellApplication {
        name = "vimr";
        text = ''
          vim -R -c 'map q :q!<CR>' "$@"
        '';
      };

    writeTclApplication =
      { name
      , text
      , runtimeInputs ? [ ]
      , checkPhase ? null
      }:
      super.writeTextFile {
        inherit name;
        executable = true;
        destination = "/bin/${name}";
        allowSubstitutes = true;
        preferLocalBuild = false;
        text = ''
          #!${self.tcl-8_6}/bin/tclsh

          ${text}
        '';

        checkPhase =
          if checkPhase == null then ''
            export PATH=${lib.makeBinPath [self.tcl-8_6]}
            runHook preCheck
            ${self.nagelfar}/bin/nagelfar -s ${self.nagelfar}/lib/syntaxdb86.tcl "$target"
            runHook postCheck
          ''
          else checkPhase;
      };
    })
  ];
  programs.bat.enable = true;
  programs.broot.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.eza.enable = true;

  programs.fzf.enable = true;

  programs.git = {
    delta.enable = true;
    enable = true;

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
      "venv"
    ];

  };

  programs.htop.enable = true;
  programs.home-manager.enable = true;
  programs.jq.enable = true;

  programs.less = {
    enable = true;
    keys = ''
      #env
      LESS = -j10 -R
    '';
  };

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
      directory = {
        truncation_length = 10;
      };
      nix_shell = {
        pure_msg ="pure";
        impure_msg ="";
      };
      shell = {
        disabled = false;
        style = "yellow";
      };
      status = {
        disabled = false;
        map_symbol = true;
        format = "[$status $common_meaning$signal_name]($style) ";
      };
    };
  };

  programs.tealdeer.enable = true;

  programs.tmux = {
    baseIndex = 1;
    clock24 = true;
    enable = true;
    extraConfig = readFile ./tmuxrc;
    keyMode = "vi";
    newSession = true;
    plugins = with pkgs.tmuxPlugins; [
      extrakto
      fpp
      logging
      pain-control
      power-theme
      resurrect
      tmux-fzf
      tmux-thumbs
    ];
  };

  programs.vim = {
    enable = true;
    packageConfigurable = lib.mkDefault (pkgs.vim_configurable.override {
      config = {
        vim = { gui = "none"; };
      };
    });

    extraConfig = readFile ./vimrc;
    plugins = with pkgs.vimPlugins; [
      ale
      nginx-vim
      unite
      vim-airline
      vim-dirdiff
      vim-indent-object
      vim-jinja
      vim-endwise
      vim-nix
      vim-repeat
      vim-sensible
      SyntaxRange
      vim-surround
    ] ++ (with pkgs; [
      vim-myplugin
    ]);
  };

  programs.zoxide.enable = true;

  programs.zsh = {

    autocd = true;
    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;

    oh-my-zsh = {
      plugins = [
        "colored-man-pages"
        "dirhistory"
        "httpie"
        "urltools"
        "vi-mode"
      ];
    };

    shellAliases = rec {
      # git shell aliases
      g = "git status";
      ga = "git add";
      gap = "git add -p";
      gb = "git branch";
      gbr = "git br"; # See programs.git
      gc = "git commit";
      gca = "git commit -a";
      gcam = "git commit -am";
      gcae = "git commit --amend";
      gcan = "git commit --amend --no-edit";
      gcana = "git commit --amend --no-edit -a";
      gcp = "git cherry-pick";
      gco = "git checkout";
      gcob = "git checkout -b";
      gcm = "git commit -m";
      gf = "git fetch";
      ggs = gitls;
      gi = "git diff";
      gica = "git diff --cached";
      gita = "git add";
      gitaww = "git diff -w --no-color | git apply --cached --ignore-whitespace"; # add changes, ignore whitespace
      gitb = "git bisect";
      gitc = "git commit";
      gitd = "git diff";
      gitdc = "git diff --cached";
      gitl = "git log";
      gitls = "git log --pretty=format:'%H %as %s (%an)'";
      gitp = "git push";
      gits = "git status";
      gl = "git pull";
      gm = "git merge";
      gmn = "git merge --no-ff";
      go = "git log";
      gp = "git push";
      gpb = "git-push-branch";
      grbc = "git rebase --continue";
      grbi = "git rebase -i";
      gsh = "git show";
      gsta = "git stash push";
      gstp = "git stash pop";
      gsts = "git stash show --text";
      x = "git annex";
      # Nix
      hm = "home-manager";
      hms = "home-manager switch";
      n = "nir";
      nib = "nix-build";
      nis = "nix search u";
      # other
      b = "bat";
      br = "broot";
      db = "dbat";
      debug = "zsh .debugrc";
      # ">c<onnect with ssh and attach/start tmux"
      c = "ssht";
      dum = "du -m --max-depth=1";
      dv = "dvimr";
      e = "export";
      fu = "fuck";
      h = "http";
      hs = "https";
      newest_file = "ls -1t | head -n1";
      pstat = "python -mpstats";
      p = "bat -pp";
      py = "python";
      run = "zsh .runrc";
      svi = "sudo -E vim";
      ta = "tmux attach";
      tj = "tar xjf";
      tl = "tldr";
      tz = "tar xzf";
      v = "vimr";
      vi = "vim";
      wip = "git add . && git commit --allow-empty -m WIP";

      # From oh-my-zsh common-aliases
      t = "tail -f";
      dud = "du -d 1 -h";
    };

    plugins = with pkgs; [
      {
        name = "fzf-tab";
        src = zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
      {
        name = "you-should-use";
        src = zsh-you-should-use;
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
      {
        # Auto-quote arguments for commands matching ZAQ_PREFIXES
        name = "zsh-autoquoter";
        src = fetchFromGitHub {
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
        src = fetchFromGitHub {
          owner = "soheilpro";
          repo = "zsh-vi-search";
          rev = "445c8a27dd2ce315176f18b4c7213c848f215675";
          sha256 = "ddqUEN6YebrVtT8Ae0ssWt2xlYxRhW5H3uRY0PoksoM=";
        };
      }
    ];

    sessionVariables = {
      BAT_PAGER = "less -R";
      TMUX_FZF_OPTIONS = "-p -w 95% -h 38% -m";
      VI_MODE_SET_CURSOR = true;
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=blue,underline";
    };

    shellGlobalAliases = {
      B = "| bat";
      P = "| bat -pp";
      C = "| cat";
      F = "| fzf";
      V = "| vimr -";
      # From oh-my-zsh common-aliases
      G = "| grep";
      J = "| jq";
      L = "| less";
      NE = "2> /dev/null";
      NUL = "> /dev/null 2>&1";
    };

    envExtra = ''
      TRAPUSR1() {
        if [[ -o INTERACTIVE ]]; then
           {echo; echo "Caught USR1, reloading zsh"} 1>&2
           exec "''${SHELL}"
        fi
      }
    '';

    initExtra = ''
      # init any-nix-shell manually, would be nice for home manager integration
      ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin

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

      # Alt-Backspace
      bindkey -M viins '^[^?' backward-kill-word
      bindkey -M viins '\e\C-h' backward-kill-word

      source ~/.keychain/`hostname`-sh &> /dev/null

      function dcd { cd "$(nix path-info "$1")" }

      # pretty json output with formatting, highlighting (by jq) and line numbers (by bat)
      function jat { jq '.' -C < "$1" | bat }

      # interactively find a PID from verbose ps output and print it
      function fpid { ps aux | fzf -m -q "$@" | awk '{ print $2 }' }

      # nix search with json output and jq filtering, can be piped to jid for interactive filtering
      function niss {
        search=$1
        shift
        nix search u --json $search | jq "$@"
      }

      function nish { nix-shell -p "$@" --run zsh }

      function ssht { ssh -t $1 'tmux attach || tmux -2' }

      # run commands via SSH like: RUN="program opt1" zsh
      # http://superuser.com/a/790681
      eval "$RUN"

      export ZAQ_PREFIXES=(
        '[^ ]#pip install( [^ ]##)# -[^ -]#'
        'git commit( [^ ]##)# -[^ -]#m'
        'gcm'
        'gcam'
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
