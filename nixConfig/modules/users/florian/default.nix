{ pkgs, ... }: {
    home.username = "florian";
    home.homeDirectory = "/home/florian";

    home.packages = with pkgs; [
        firefox
        kitty
        btop
    ];

    programs.zsh = {
        enable = true;
        oh-my-zsh = {
        enable = true;
        theme = "agnoster";
        plugins = [ "git" ];
        };
    };

    home.stateVersion = "24.05";
}