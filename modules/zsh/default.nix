# Just to enable zsh config, config is mostly in zsh/
# and also in platform-specific modules (nixos.nix/mac.nix).
{ config, pkgs, ... }:
{
  programs.zsh.enable = true;
}
