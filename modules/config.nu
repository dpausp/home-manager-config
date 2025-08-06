# config.nu
#
# Installed by:
# version = "0.105.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

# Vi mode keybindings (similar to zsh vi mode)
$env.config = {
    edit_mode: vi
    
    # Keybindings for vi mode
    keybindings: [
        {
            name: completion_menu
            modifier: none
            keycode: tab
            mode: [emacs vi_normal vi_insert]
            event: {
                until: [
                    { send: menu name: completion_menu }
                    { send: menunext }
                    { edit: complete }
                ]
            }
        }
        {
            name: history_menu
            modifier: control
            keycode: char_r
            mode: [emacs vi_normal vi_insert]
            event: { send: menu name: history_menu }
        }
        {
            name: delete_word_backward
            modifier: control_alt
            keycode: char_h
            mode: [emacs vi_insert]
            event: { edit: backspaceword }
        }
        {
            name: insert_last_word
            modifier: alt
            keycode: char_.
            mode: [vi_insert]
            event: { edit: insertstring, value: "!$" }
        }
        {
            name: escape
            modifier: none
            keycode: escape
            mode: [vi_insert]
            event: { send: esc }
        }
    ]
    
    # History configuration
    history: {
        max_size: 100_000
        sync_on_enter: true
        file_format: "plaintext"
    }
    
    # Completions (fuzzy like fzf-tab)
    completions: {
        algorithm: "fuzzy"
        case_sensitive: false
    }
    
    # Cursor shapes for vi mode  
    cursor_shape: {
        vi_insert: line
        vi_normal: block
    }
    
    # Basic settings
    show_banner: false
    buffer_editor: "vi"
}

# Git aliases (your custom set)
alias g = git status
alias ga = git add
alias gap = git add -p
alias gb = git branch
alias gbr = git br  # See programs.git
alias gc = git commit
alias gca = git commit -a
alias gcam = git commit -am
alias gcae = git commit --amend
alias gcan = git commit --amend --no-edit
alias gcana = git commit --amend --no-edit -a
alias gcp = git cherry-pick
alias gco = git checkout
alias gcob = git checkout -b
alias gcm = git commit -m
alias gf = git fetch
alias ggs = gitls
alias gi = git diff
alias gica = git diff --cached
alias gitb = git bisect
alias gitc = git commit
alias gitd = git diff
alias gitdc = git diff --cached
alias gitl = git log
alias gitls = git log --pretty=format:'%H %as %s (%an)'
alias gitp = git push
alias gits = git status
alias gl = git pull
alias gm = git merge
alias gmn = git merge --no-ff
alias go = git log
alias gp = git push
alias gpb = git-push-branch
alias grbc = git rebase --continue
alias grbi = git rebase -i
alias grv = git remote -v
alias gsh = git show
alias gsta = git stash push
alias gstp = git stash pop
alias gsts = git stash show --text

# Directory navigation aliases
alias ll = ls -la
alias la = ls -la
alias l = ls
alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..
alias ..... = cd ../../../..

# Environment setup for external tools
$env.EDITOR = "vi"
$env.VISUAL = "vi"

$env.PATH = [
    ($env.HOME | path join ".nix-profile/bin")
    ($env.HOME | path join ".local/bin")
    "/nix/var/nix/profiles/default/bin"
    "/run/current-system/sw/bin"
    "/Applications/iTerm.app/Contents/Resources/utilities"
    "/opt/homebrew/bin"
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
    "/usr/sbin"
    "/sbin"
]

source ~/completions.nu
source ~/rovodev.nu


