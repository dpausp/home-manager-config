# NixOS-specific settings that require X11.
{ pkgs, ... }:

with builtins;

{
  programs.tmux.extraConfig = ''
    bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -sel clip -i"
    bind C-v run "tmux set-buffer \"$(xclip -sel clip -o)\"; tmux paste-buffer"
  '';
}
