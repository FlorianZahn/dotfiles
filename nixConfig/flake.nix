{
    description = "Meine fortgeschrittene modulare NixOS-Konfiguration";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        sops-nix.url = "github:Mic92/sops-nix";
    };

    outputs = { self, nixpkgs, home-manager, ... }@inputs:
        let
        # --- HELFER-FUNKTIONEN ---

        # Helfer 1: Baut die Home-Manager-Konfigurationen für einen Host
        mkHomeManagerUsers = hostPath: userNames: nixpkgs.lib.genAttrs userNames (userName: {
            imports =
                # Füge die gemeinsame Core-Benutzerkonfiguration hinzu, ABER NUR, WENN SIE EXISTIERT
                (
                    if builtins.pathExists ./modules/users/${userName}
                    then [ ./modules/users/${userName} ]
                    else [ ]
                ) ++
                # Baue eine Liste von Modulen, die importiert werden sollen
                [
                    # Importiere die Host-spezifische Benutzerkonfiguration
                    "${hostPath}/users/${userName}"
                ];
        });

        # Helfer 2: Baut ein komplettes NixOS-System
        mkNixosSystem = hostPath: system: nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit inputs; };
            modules = [
                sops-nix.nixosModules.sops
                # Importiere die gemeinsame Core-Systemkonfiguration für ALLE Hosts
                ./modules/system/core

                # Importiere die Hauptkonfiguration des Hosts (die `default.nix`)
                hostPath

                # Aktiviere Home Manager
                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    # Rufe unseren Helfer auf, um die Benutzer für diesen Host zu bauen.
                    # Er liest die Benutzerliste aus der Host-Konfiguration.
                    home-manager.users = mkHomeManagerUsers hostPath hostPath.config.host.users;
                }
            ];
        };

        hostDefinitions = {
            "Desktop-Home" = "/client/Desktop-Home";
            "Laptop-Hp"    = "/client/Laptop-Hp";
            "Test-NixOs"   = "/vm/Test-NixOs";
        };
        systems = nixpkgs.lib.mapAttrs (hostName: pathString: (./hosts)${pathString}) hostDefinitions;

        in
        {
        # Baut automatisch eine Konfiguration für jeden in `systems` definierten Host
        nixosConfigurations = nixpkgs.lib.mapAttrs (hostName: hostPath: mkNixosSystem hostPath hostPath.config.host.system) systems;
        homeConfigurations = nixpkgs.lib.mapAttrs (hostName: hostPath:
            let
                system = hostPath.config.host.system;
                pkgs = nixpkgs.legacyPackages.${system};
            in
            nixpkgs.lib.genAttrs hostPath.config.host.users (userName:
                nixpkgs.lib.nameValuePair "${userName}@${hostName}" (
                home-manager.lib.homeManagerConfiguration {
                    inherit pkgs;
                    modules = (mkHomeManagerUsers hostPath [ userName ]).${userName}.imports;
                }
                )
            )
            ) systems;
        formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
        };
}