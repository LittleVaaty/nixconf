{
  description = "My custom multi-machine system flake.";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
        url = "github:LnL7/nix-darwin";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };
  outputs = { self, nixpkgs, home-manager, nix-darwin, nix-homebrew, ... } @ inputs: 
  let
    # inherit (self) outputs;
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        inputs.nur.overlay
      ];

      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
    #  Export Variables
    stateVersion = "24.05"; # TODO: change stateVersion
    username = "vaaty"; # TODO: change username
    desktop = "yoitsu"; # TODO: Change Desktop name
    laptop = "laptop"; # TODO: change Laptop name
    mac = "jonathans-Mini"; # TODO: change Laptop name
    system = "x86_64-linux"; # TODO: Rarely, change system architecture
  in {

    darwinConfigurations."mini" = nix-darwin.lib.darwinSystem {
        modules = [ 
          ./hosts/mini/configuration.nix 
          nix-homebrew.darwinModules.nix-homebrew 
          {
              nix-homebrew = {
                  enable = true;
                  enableRosetta = true;
                  user = "vaaty";
                  autoMigrate = true;
                };
            }
        ];
    };

    darwinPackages = self.darwinConfigurations."mini".pkgs;

    #  Standalone home-manager configuration entrypoint
    #  Available through 'home-manager --flake .# your-username@your-hostname'
    homeConfigurations = {
      "${username}@${mac}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs; #  > Our main home-manager configuration file <
        modules = [./hosts/${mac}/home.nix];
        extraSpecialArgs = let
          hostname = mac;
        in {
          inherit
            self
            inputs
            username
            hostname
            system
            stateVersion
            ;
        };
      };
      "${username}@${laptop}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs; #  > Our main home-manager configuration file <
        modules = [./hosts/${laptop}/home.nix];
        extraSpecialArgs = let
          hostname = laptop;
        in {
          inherit
            self
            inputs
            username
            hostname
            system
            stateVersion
            ;
        };
      };
    };
  };
}
