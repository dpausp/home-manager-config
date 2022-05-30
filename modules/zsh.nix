# Just to enable zsh config, config is mostly in base-common.nix
# and also in platform-specific modules (nixos.nix/mac.nix).
{
  programs.zsh.enable = true;
  programs.zsh.oh-my-zsh.enable = true;
}
