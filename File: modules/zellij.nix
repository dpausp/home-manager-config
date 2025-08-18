{
  config,
  pkgs,
  lib,
  ...
}:

{
  programs.zellij = {
    enable = true;
  };
  # Create zellij config file similar to tmuxrc
  xdg.configFile."zellij/config.kdl".text = ''
    keybinds {

        // Collides with fzf
        unbind "Ctrl t"
        // Collides with navi
        unbind "Ctrl g"
        normal {
            bind "Ctrl e" { SwitchToMode "tmux"; }
            bind "Ctrl b" { SwitchToMode "tab"; }
        }

        tmux {
            // Tab navigation (existing)
            bind "b" { GoToPreviousTab; SwitchToMode "Normal"; }
            bind "n" { GoToNextTab; SwitchToMode "Normal"; }
            bind "c" { NewTab; SwitchToMode "Normal"; }
            bind "f" { ToggleFloatingPanes; }
            
            bind "1" { GoToTab 1; }
            bind "2" { GoToTab 2; }
            bind "3" { GoToTab 3; }
            bind "4" { GoToTab 4; }
            bind "5" { GoToTab 5; }
            bind "6" { GoToTab 6; }
            bind "7" { GoToTab 7; }
            bind "8" { GoToTab 8; }
            bind "9" { GoToTab 9; }
            bind "0" { GoToTab 10; }
            bind "h" { TogglePaneFrames; }
            bind "l" { NextSwapLayout; SwitchToMode "Normal"; }
            bind "g" {