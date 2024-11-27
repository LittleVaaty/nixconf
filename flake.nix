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
    nix-colors.url = "github:misterio77/nix-colors";
    stylix.url = "github:danth/stylix";
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
    stateVersion = "24.05";
    username = "vaaty";
    desktop = "desktop";
    laptop = "laptop";
    mac = "mini";
    system = "x86_64-linux";
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
        pkgs = nixpkgs.legacyPackages."aarch64-darwin";

        modules = [./hosts/${mac}/home.nix];
        extraSpecialArgs = {
          inherit inputs;
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
