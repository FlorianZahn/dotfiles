{
  description = "My Flakie";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware.url = "github:nixos/nixos-hardware";
  };  

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
    let 
      system = "x86_64-linux";
    in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#FlorianDesktopNixOs'
    nixosConfigurations = {
      FlorianDesktopNixOs = nixpkgs.lib.nixosSystem {
				inherit system;
        specialArgs = { inherit inputs; };
        modules = [ 
          ./nixos/configuration.nix
        ];
      };
    };

    # home-manager configuration entrypoint
    # Available through 'home-manager --flake .#florian@FlorianDesktopNixOs'
    homeConfigurations = {
      "florian@FlorianDesktopNixOs" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit inputs; };
        modules = [ 
            ./home-manager/home.nix 
            ];
      };
    };
  };
}