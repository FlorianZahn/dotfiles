
{ ... }: {
    networking.hostName = "Desktop-Home-NixOs";

    users = {
        florian = {
            imports = [
                ../../modules/users/florian/default.nix
                ./florian/default.nix
            ];
        };
        # You could add another user here, e.g.:
        # guest = { imports = [ ../../modules/users/guest/default.nix ]; };
    };
}