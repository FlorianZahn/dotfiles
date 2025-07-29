# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "FlorianDesktopNixOs";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;

  users.users.florian = {
    isNormalUser = true;
    extraGroups = [ "networkmanager wheel" ];
    packages = with pkgs; [
      tree
    ];
    shell = pkgs.zsh;
  };

  programs.firefox.enable = true;
  programs.hyprland.enable = true; 
  programs.zsh.enable = true;
  xdg.portal.enable = true;


  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    neovim
    vim
    wget
    curl
    git
    kitty
    nautilus
    vscode
    pavucontrol
    unzip
    rofi-wayland
  ];

  # Services
  services.openssh.enable = true;

  system.stateVersion = "25.05";

}

