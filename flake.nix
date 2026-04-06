{
  description = "fleet - system configs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
    }:
    {
      darwinConfigurations.zhora = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./zhora/configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.users.iaz = import ./zhora/home.nix;
          }
        ];
      };

      nixosConfigurations.roy = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./roy/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-amanger.users.iaz = import ./roy/home.nix;
          }
        ];
      };
    };
}
