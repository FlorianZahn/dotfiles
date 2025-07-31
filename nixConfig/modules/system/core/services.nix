{ ... }: {
    networking.networkmanager.enable = true;
    services.pipewire.enable = true;
    services.pipewire.pulse.enable = true;
    services.openssh.enable = true;
    programs.zsh.enable = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    system.stateVersion = "24.05";
}