{
  description = "My nix configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: 
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
        inherit system;

        config = {
            allowUnfree = true;
          };
      };
  in 
  {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs system; };
        
        modules = [
          ./nixos/configuration.nix
        ];
      };
    };

    homeConfigurations = {
        "vaaty@laptop" =  home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit nixpkgs system; };
        modules = [ 
          ./homeManagerModules/git.nix 
          ./nixos/home.nix
        ];
      };
      }
  };
}
