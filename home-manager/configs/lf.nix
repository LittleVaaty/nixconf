
{ config, pkgs, ... }:
{

	home.packages = with pkgs; [
    lf
	];

  programs.lf = {
    enable = true;
  
  };
  
}
