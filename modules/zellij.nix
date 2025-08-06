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

            bind "g" { MoveFocus "Up"; }
            bind "n" { MoveFocus "Left"; }
            bind "r" { MoveFocus "Down"; }
            bind "t" { MoveFocus "Right"; }
            
            // Pane splitting (new - tmux style)
            bind "\"" { NewPane "Down"; SwitchToMode "Normal"; }     // horizontal split (pane below)
            bind "%" { NewPane "Right"; SwitchToMode "Normal"; }     // vertical split (pane right)
            bind "-" { NewPane "Down"; SwitchToMode "Normal"; }      // alternative horizontal split
            bind "|" { NewPane "Right"; SwitchToMode "Normal"; }     // alternative vertical split
            bind "s" { NewPane "Down"; SwitchToMode "Normal"; }      // alternative horizontal split
            bind "v" { NewPane "Right"; SwitchToMode "Normal"; }     // alternative vertical split
            
            // Pane management (new)
            bind "x" { CloseFocus; SwitchToMode "Normal"; }          // close current pane
            bind "z" { ToggleFocusFullscreen; SwitchToMode "Normal"; } // zoom pane
            bind "Space" { NextSwapLayout; SwitchToMode "Normal"; }   // cycle layouts
            
            // Copy/Paste mode (existing and new)
            bind "Esc" { SwitchToMode "EnterSearch"; }
            bind "p" { SwitchToMode "Normal"; }                      // paste (zellij handles this differently)
            
            // Pane resizing (new)
            bind "G" { Resize "Increase Up"; }
            bind "N" { Resize "Increase Left"; }
            bind "R" { Resize "Increase Down"; }
            bind "T" { Resize "Increase Right"; }
            bind "Ctrl g" { Resize "Decrease Left"; }
            bind "Ctrl n" { Resize "Decrease Down"; }
            bind "Ctrl r" { Resize "Decrease Up"; }
            bind "Ctrl t" { Resize "Decrease Right"; }
            
            // Session management (existing and new)
            bind "d" { Detach; }
            bind "F12" { Detach; }
            bind "Ctrl c" { SwitchToMode "Normal"; }
            bind "q" { SwitchToMode "Normal"; }
        }
        
        scroll {
            // Basic navigation
            bind "j" { ScrollDown; }
            bind "k" { ScrollUp; }
            bind "y" { Copy; SwitchToMode "Normal"; }
            bind "Esc" { SwitchToMode "Normal"; }
            
            // Vim-style navigation (only supported actions)
            bind "g" { ScrollToTop; }
            bind "G" { ScrollToBottom; }
            bind "Ctrl u" { HalfPageScrollUp; }
            bind "Ctrl d" { HalfPageScrollDown; }
            bind "Ctrl b" { PageScrollUp; }
            bind "Ctrl f" { PageScrollDown; }
        }
    }

    mouse_mode true
    copy_command "pbcopy"
    default_shell "zsh"
  '';

  # Add zellij aliases similar to tmux (ta = "tmux attach")
  programs.zsh = {
    shellAliases = {
      za = "zellij attach";
      zl = "zellij list-sessions";
      zk = "zellij kill-session zellij $SESSION_NAME";
    };

    initContent = ''
      # Zellij equivalent of ssht function from tmux config
      function zssh { ssh -t $1 'zellij attach || zellij' }
    '';
  };
}
