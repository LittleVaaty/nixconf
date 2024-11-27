{ config, pkgs, ... }:

{
  imports = [
    ./starship/starship.nix
    ./alacritty.nix
    ./lf.nix
    ./git.nix
    ./stylix.nix
  ];
}
