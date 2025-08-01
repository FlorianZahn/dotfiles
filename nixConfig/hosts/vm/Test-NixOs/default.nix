{ ... }: {
    imports = [
        ./hardware-configuration.nix
        #../../../modules/system/core

        # 3. (Optional) Import any optional system modules for this machine
        # For example, if you had a `gaming.nix` module:
        # ../../modules/system/optional/gaming.nix
    ];
}