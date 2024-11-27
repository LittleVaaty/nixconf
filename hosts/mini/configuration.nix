{ pkgs, config, ...}: {

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    pkgs.lf
    pkgs.alacritty
    pkgs.neovim
    pkgs.tmux
    pkgs.mkalias
    pkgs.obsidian
    pkgs.fish
    pkgs.bottom
  ];

  networking.hostName = "mini";

  programs.fish.enable = true;
  users.users = {
    vaaty = {
      home = "/Users/vaaty";
      shell = pkgs.fish;
    };
  };

  fonts.packages = [
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono"]; })
  ];

  homebrew = {
      enable = true;
      casks = [
        "iina"
        "firefox"
        "spotify"
      ];
      onActivation.cleanup = "zap";
      onActivation.autoUpdate = true;
      onActivation.upgrade = true;
    };

  system.defaults = {
      dock.autohide = true;
    };

  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = 4;

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.activationScripts.applications.text = let
  env = pkgs.buildEnv {
    name = "system-applications";
    paths = config.environment.systemPackages;
    pathsToLink = "/Applications";
  };
  in
    pkgs.lib.mkForce ''
    # Set up applications.
    echo "setting up /Applications..." >&2
    rm -rf /Applications/Nix\ Apps
    mkdir -p /Applications/Nix\ Apps
    find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
    while read -r src; do
      app_name=$(basename "$src")
      echo "copying $src" >&2
      ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
    done
  '';
}
