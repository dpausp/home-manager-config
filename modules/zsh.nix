{ config, pkgs, lib, ... }: {
  home.sessionVariables = {
    DELTA_PAGER = "bat";
    LC_MESSAGES = "C";
    EDITOR = "vim";
  };

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "dirhistory" "vi-mode" ];
    };

    shellAliases = {
      # annex
      x = "git annex";
      xs = "git push belakor master";

      # git
      gita = "git add";
      # add changes, ignore whitespace
      gitaww = "git diff -w --no-color | git apply --cached --ignore-whitespace";
      gitd = "git diff";
      gitdc = "git diff --cached";
      gitl = "git log";
      gitls = "git log --pretty=format:'%H %as %s (%an)'";
      gitc = "git commit";
      gits = "git status";
      gitb = "git bisect";
      gitp = "git push";

      # other
      newest_file = "ls -1t | head -n1";
      dum = "du -m --max-depth=1";
      tz = "tar xzf";
      tj = "tar xjf";
      ls = "ls --color";
      pstat = "python -mpstats";
      py = "python";
      ll = "exa -l";
      la = "exa -la";
      svi = "sudo -E vim";
      run = "zsh .runrc";
      debug = "zsh .debugrc";
      hm = "home-manager";
      vi = "vim";
    };

    shellGlobalAliases = {
      F = "| fzf";
    };

    envExtra = ''
      # XXX: skip permission check for testing via another user
      export ZSH_DISABLE_COMPFIX=true
    '';

    initExtra = ''
      # init any-nix-shell manually, would be nice for home manager integration
      any-nix-shell zsh --info-right | source /dev/stdin

      eval $(thefuck --alias fu)

      # disable hosts completion because I use /etc/hosts to block many unwanted sites that would appear as completions without that setting
      zstyle ':completion:*:*:*' hosts off

      bindkey -M viins '^[.' insert-last-word # Alt-.
      bindkey -M vicmd '^[.' insert-last-word # Alt-.

      bindkey -M viins '^[^?' backward-kill-word # Alt-Backspace

      source ~/.keychain/`hostname`-sh &> /dev/null

      function xg {
        git annex get "$@"
        git annex copy --to belakor "$@"
      }

      function git-push-branch {
        git push -u origin $(git rev-parse --abbrev-ref HEAD)
      }

      # pretty json output with formatting, highlighting (by jq) and line numbers (by bat)
      function jat { jq '.' -C < "$1" | bat }

      # interactively find a PID from verbose ps output and print it
      function fpid { ps aux | fzf -m -q "$@" | awk '{ print $2 }' }

      # nix search with json output and jq filtering, can be piped to jid for interactive filtering
      function nis() { search=$1; shift; nix search --json $search | jq "$@" }

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

      eval "$(direnv hook zsh)"

      TRAPHUP() {
            print "Caught HUP, reloading zsh"
              . ~/.zshrc
      }

      # run commands via SSH like: RUN="program opt1" zsh
      # # http://superuser.com/a/790681
      eval "$RUN"
    '';
  };
}
