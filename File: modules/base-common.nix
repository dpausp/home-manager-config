{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:

with builtins;

let
  home = config.home.homeDirectory;
in
{
  home.packages =
    with pkgs;
    [
      amber
      apg
      bc
      bottom
      delta
      dhall
      diceware
      doggo
      pkgs-unstable.doit # macfsevents 0.8.4 build error
      duf
      dust
      entr
      fd
      file
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
      hyperfine
      inCmd
      inetutils
      ipcalc
      jid
      #lnavGit
      magic-wormhole
      mailutils
      mosh
      nagelfar
      netcat-gnu
      mtr
      nixfmt-tree
      nmap
      ntfy-sh
      nvd
      pastel
      pipe-rename
      procs
      pssh
      remarshal
      rich-cli
      ripgrep
      sd
      sharutils
      shellcheck
      socat
      sqlite
      statix
      sshuttle
      pkgs-unstable.tailscale
      statix
      thefuck
      thumbs
      tokei
      tree
      unzip
      wrk
      zip
    ]
    ++ [
      dbat
      dcd
      dvimr
      findUpCmd
      fpid
      gen-passphrase
      hlepCmd
      inCmd
      jat
      n
      niss
      outCmd
      rwhich
      ssht
      sshz
      vimr
    ];

  home.enableNixpkgsReleaseCheck = true;
  home.sessionPath = [
    "$HOME/.local/bin"
  ];
  home.sessionVariables = {
    DELTA_PAGER = "bat";
    LC_MESSAGES = "C";
  };

  nixpkgs.overlays = [
    (self: super: {
      inherit (pkgs-unstable) delta lnav;
      lnavGit =
        let
          rev = "a49c37e0af4392d6dd78b03efb5e78bcbeebc744";
        in
        pkgs-unstable.lnav.overrideAttrs (old: {
          version = "2025-06-05-${builtins.substring 0 7 rev}";
          name = "lnav-unstable";
          src = pkgs.fetchFromGitHub {
            owner = "tstack";
            repo = "lnav";
            inherit rev;
            sha256 = "sha256-CSt33LfKwhV6fzEuRI3t/2avkMfBAsrCgw75cbJ5gqM=";
          };
          patches = [ ];
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
            sha256 = "sha256-BfQkVxVwT+hjb2T13H1EPKXS+W5FIJyQkR+Iz9079FU=";
          };
          postInstall = ''
            for f in extrakto.sh open.sh; do
              wrapProgram $target/scripts/$f \
                --prefix PATH : ${
                  with pkgs;
                  lib.makeBinPath ([
                    pkgs.fzf
                    pkgs.python3
                  ])
                }
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
            sha256 = "sha256-sw9g1Yzmv2fdZFLJSGhx1tatQ+TtjDYNZI5uny0+5Hg=";
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

      dcd = pkgs.writeShellApplication {
        name = "dcd";
        text = ''
          if [[ $# -eq 0 ]]; then exit 1; fi
          cd "$(nix path-info "$@")"
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

      hlepCmd = pkgs.writeShellApplication {
        name = "hlep";
        text = ''
          if [[ $# -eq 1 ]]; then
            cmd="$1"

            # Versuche --help
            if "$cmd" --help &> /dev/null; then
              "$cmd" --help | bat
              return
            fi

            # Versuche -h
            if "$cmd" -h &> /dev/null; then
              "$cmd" -h | bat
              return
            fi

            # Versuche man
            if man "$cmd" &> /dev/null; then
              man "$cmd"
              return
            fi

            echo "Helpless: $cmd."
          else
            echo "Usage: help <command>"
          fi
        '';
      };

      nbCmd = pkgs.writeTclApplication {
        name = "nb";
        text = ''
          if {$argc == 0} {
              puts "Usage: $argv0 pkg1 pkg2 ..."
              exit 1
          }

          set packages {}
          foreach pkg $argv {
              lappend packages "nixpkgs#$pkg"
          }

          set command "nom build [join $packages]"

          eval $command
          '';
          };

      fpid = pkgs.writeShellApplication {
        name = "fpid";
        text = ''
          ps aux | fzf -m -q "$@" | awk '{ print $2 }'
        '';
      };

      gen-passphrase = pkgs.writeShellApplication {
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

      jat = pkgs.writeShellApplication {
        name = "jat";
        text = ''
          jq '.' -C < "$1" | bat
        '';
      };

      nagelfar = super.nagelfar.overrideAttrs (prev: {
        installPhase = prev.installPhase + ''
          mkdir $out/lib
          cp $src/syntax*.tcl $out/lib/
        '';
      });

      n = pkgs.writeShellApplication {
        name = "n";
        text = ''
          nom run nixpkgs#"$1"
        '';
      };


      niss = pkgs.writeShellApplication {
        name = "niss";
        text = ''
          search="$1"
          shift
          nix search u --json "$search" | jq "$@"
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
        makeFlags = [
          "PREFIX=$(out)"
          "BASHCOMPDIR=$(out)/etc/bash_completion.d"
        ];

        src = pkgs.fetchFromGitHub {
          owner = "palortoff";
          repo = "pass-extension-tail";
          rev = "784e3e17edd8de4bd3493b75e19165cc5e80c5a0";
          sha256 = "sha256-1irxp0jygjb5yn2jjg7hf25b2499d91crznq2yfs3iz0h9dxf8s7";
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

      ssht = pkgs.writeShellApplication {
        name = "ssht";
        text = ''
          ssh -t "$1" 'tmux attach || tmux -2'
        '';
      };

      sshz = pkgs.writeShellApplication {
        name = "sshz";
        text = ''
          ssh -t "$1" 'zellij attach --create default'
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
        {
          name,
          text,
          runtimeInputs ? [ ],
          checkPhase ? null,
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
            if checkPhase == null then
              ''
                export PATH=${lib.makeBinPath [ self.tcl-8_6 ]}
                runHook preCheck
                ${self.nagelfar}/bin/nagelfar -s ${self.nagelfar}/lib/syntaxdb86.tcl "$target"
                runHook postCheck
              ''
            else
              checkPhase;
        };
    })
  ];

  programs = {
    bat.enable = true;
    broot.enable = true;
    carapace.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    eza.enable = true;
    fzf.enable = true;
  };

  programs.git = {
    delta.enable = true;
    enable = true;

    aliases = {
      co = "checkout";
      re = "rebase";
      id = "rev-parse HEAD";
      br = "for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'";
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

      diff = {
        colorMoved = "default";
      };

      difftool = {
        prompt = false;
      };

      fetch = {
        fsckObjects = true;
      };

      init = {
        defaultBranch = "main";
      };

      merge = {
        conflictstyle = "diff3";
      };

      "protocol \"http\"" = {
        allow = "never";
      };

      pull = {
        ff = "only";
      };

      rebase = {
        instructionFormat = "%at <%ae> %s";
      };

      transfer = {
        fsckObjects = true;
      };

      receive = {
        fsckObjects = true;
      };
    };

    ignores = [
      ".aicodingrc"
      ".aider.chat.history.md"
      ".aider.input.history"
      ".aider.tags.cache.v4/"
      ".dbeaver-data-sources.xml"
      ".idea"
      ".in-syncrc"
      ".out-syncrc"
      ".project"
      ".pydevproject"
      ".runrc"
      ".settings"
      ".updaterc"
      ".vscode"
      "venv"
    ];
  };

  programs.htop.enable = true;
  programs.home-manager.enable = true;
  programs.jq.enable = true;

  programs.less = {
    enable = true;
    config = ''
      #env
      LESS = -j10 -R
    '';
  };

  programs.navi.enable = true;
  programs.nix-index.enable = true;
  programs.nix-your-shell.enable = true;

  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [
      exts.pass-genphrase
      pkgs.pass-tail
    ]);
    settings = {
      PASSWORD_STORE_DIR = "${home}/.password-store";
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      directory = {
        truncation_length = 5;
        truncate_to_repo = false;
        truncation_symbol = ".../";
        before_repo_root_style = "#333333";
      };

      git_commit = {
        disabled = false;
        format = "on [$hash]($style) ";
        style = "bold green";
        only_detached = false;
        tag_disabled = false;
        tag_symbol = " tag ";
        commit_hash_length = 7;
      };

      nix_shell = {
        pure_msg = "pure";
        impure_msg = "";
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
      username = {
        show_always = true;
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
}
