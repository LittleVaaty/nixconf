{ config, pkgs, ... }:

{

	home.packages = with pkgs; [
    git
	];

  programs.git = {
    enable = true;
    userEmail = "hansen-jonathan@hotmail.com";
    userName = "LittleVaaty";
  };
  
}
