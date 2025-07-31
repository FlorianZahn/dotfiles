{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        git
        neovim
        wget
    ];
    nixpkgs.config.allowUnfree = true;
}