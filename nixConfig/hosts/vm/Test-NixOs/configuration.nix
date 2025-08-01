{ config, pkgs, ... }:

{
    # 1. Define our custom host options
    # These are read by your flake.nix to build the system correctly.
    host = {
        system = "x86_64-linux";
        users = [ "florian" ];
    };

    # 2. Define the 'florian' user and their system-level properties
    users.users.florian = {
        isNormalUser = true;
        description = "Florian";
        extraGroups = [ "wheel" ]; # Add user to the wheel group for sudo access
    };

    # 3. Add some essential system settings
    # This section is where you would configure your bootloader, networking, etc.
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda"; # IMPORTANT: Change this to your boot device

    networking.hostName = "Test-NixOs"; # Or whatever you want to call this machine
}