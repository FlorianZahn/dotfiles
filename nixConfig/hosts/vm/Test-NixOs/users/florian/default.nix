{ config, pkgs, ... }:

{
    # Set your username and home directory.
    home.username = "florian";
    home.homeDirectory = "/home/florian";

    # This value helps manage backwards compatibility. For a new config,
    # set it to the current NixOS release version you are on.
    home.stateVersion = "25.05";

    # Packages to install in your user profile.
    home.packages = with pkgs; [
        git
        neovim
        ripgrep # A fast code-searching tool
    ];

    # Basic git configuration.
    programs.git = {
        enable = true;
        userName = "Florian Zahn";
        userEmail = "anderes.zeug@outlook.com";
    };

    # Basic shell configuration for Bash.
    programs.bash = {
        enable = true;
        enableCompletion = true;
        shellAliases = {
        ll = "ls -alF";
        ".." = "cd ..";
        };
    };

    # This allows you to manage files in your home directory declaratively.
    # For example, to create a file named .testfile with some content:
    # home.file.".testfile".text = "hello world";
}