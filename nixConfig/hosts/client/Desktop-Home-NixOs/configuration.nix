
{ ... }: {
    networking.hostName = "Desktop-Home-NixOs";

    users = {
        florian = {
            imports = [
                ../../modules/users/florian/bundle.nix
                ./florian/bundle.nix
            ];
        };
        # You could add another user here, e.g.:
        # guest = { imports = [ ../../modules/users/guest/bundle.nix ]; };
    };
}