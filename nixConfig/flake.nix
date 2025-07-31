{
    description = "My modular NixOS configuration with nested hosts";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        # Add other inputs like 'hardware' if needed
    };

    outputs = { self, nixpkgs, home-manager, ... }@inputs:
        let
        system = "x86_64-linux";

        # --- HOST DEFINITIONS ---
        # This is the central map of all your systems.
        # The key is the hostname you use in the build command (e.g., .#Desktop-Home).
        # The value is the path to that host's main configuration file.
        systems = {
            "Desktop-Home" = ./hosts/client/Desktop-Home-NixOs;
            "Laptop-Hp"    = ./hosts/client/Laptop-Hp;
            "Test-NixOs"    = ./hosts/vm/Test-NixOs;
            # Add other hosts here, for example:
            # "proxmox-vm" = ./nixConfig/hosts/vm/proxmox-vm;
        };

        # A helper function to build a NixOS system from a given path
        mkNixosSystem = hostPath: nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit inputs; }; # Makes inputs available to all modules
            modules = [
                # The main entrypoint for the host's system configuration
                hostPath

                # Enable and configure Home Manager for this host
                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    # This imports the `users` attribute set from the host's configuration.nix
                    home-manager.users = (import "${hostPath}/configuration.nix").users;
                }
            ];
        };

        in
        {
        # Automatically generate a nixosConfigurations output for every host defined in `systems`
        nixosConfigurations = nixpkgs.lib.mapAttrs (hostName: hostPath: mkNixosSystem hostPath) systems;
        };
}
