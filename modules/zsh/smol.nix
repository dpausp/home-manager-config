{
  pkgs,
  ...
}:

with builtins;

{
  programs.zsh = {

    autocd = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

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
      gf = "git fetch -v";
      gfa = "git fetch --all -v";
      gi = "git diff";
      gica = "git diff --cached";
      gitaww = "git diff -w --no-color | git apply --cached --ignore-whitespace"; # add changes, ignore whitespace
      gl = "git pull";
      gm = "git merge";
      gmn = "git merge --no-ff";
      go = "git log";
      gos = "git log --pretty=format:'%H %as %s (%an)'";
      gp = "git push";
      gpb = "git-push-branch";
      grbc = "git rebase --continue";
      grbi = "git rebase -i";
      grv = "git remote -v";
      gsh = "git show";
      gsta = "git stash push";
      gstp = "git stash pop";
      gsts = "git stash show --text";
      x = "git annex";
      help = "hlep";
      # Nix
      nib = "nix-build";
      nis = "nix search n";
      # other
      b = "bat";
      br = "broot";
      db = "dbat";
      debug = "zsh .debugrc";
      # ">c<onnect with ssh and attach/start tmux"
      c = "ssht";
      cz = "sshz";
      dum = "du -m --max-depth=1";
      dv = "dvimr";
      e = "export";
      h = "http";
      hs = "https";
      pate = "pbpaste | tee";
      newest_file = "ls -1t | head -n1";
      pstat = "python -mpstats";
      p = "bat -pp";
      run = "zsh .runrc";
      svi = "sudo -E vim";
      ta = "tmux attach";
      tj = "tar xjf";
      tl = "tldr";
      tz = "tar xzf";
      update = "zsh .updaterc";
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
        # Auto-quote arguments for commands matching ZAQ_PREFIXES
        name = "zsh-autoquoter";
        src = fetchFromGitHub {
          owner = "ianthehenry";
          repo = "zsh-autoquoter";
          rev = "9e3b1b216bf7b61a9807a242bae730b5fc232a44";
          hash = "sha256-CdyKIGxOnWGWPeBuNz067zp8/a394H0Ec2h3CA3oIx0=";
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
          hash = "ddqUEN6YebrVtT8Ae0ssWt2xlYxRhW5H3uRY0PoksoM=";
        };
      }
    ];

    sessionVariables = {
      BAT_PAGER = "less -R";
      TMUX_FZF_OPTIONS = "-p -w 95% -h 38% -m";
      VI_MODE_SET_CURSOR = true;
      ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=blue,underline";
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

    initContent = readFile ./init_content_smol.zsh;
  };
}
