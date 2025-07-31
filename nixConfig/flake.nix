{
    description = "My modular NixOS configuration";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { self, nixpkgs, home-manager, ... }@inputs:
        let
        system = "x86_64-linux";

        # A helper function to build a complete NixOS system for a given host
        mkNixosSystem = hostName: nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit inputs; }; # Makes inputs available to all modules
            modules = [
            # The main entrypoint for the host's system configuration
            ./nixConfig/hosts/${hostName}/bundle.nix

            # Enable and configure Home Manager for this host
            home-manager.nixosModules.home-manager
            {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                # This is the magic part: it reads the `users` attribute set from the
                # host's configuration.nix and builds a Home Manager config for each user.
                home-manager.users = (import ./nixConfig/hosts/${hostName}/configuration.nix).users;
            }
            ];
        };

        # Automatically find all hostnames by looking at the directory names in ./hosts
        hostNames = builtins.attrNames (builtins.readDir ./nixConfig/hosts);

        in
        {
        # Automatically generate a nixosConfigurations output for every host found
        nixosConfigurations = nixpkgs.lib.genAttrs hostNames mkNixosSystem;
        };
}