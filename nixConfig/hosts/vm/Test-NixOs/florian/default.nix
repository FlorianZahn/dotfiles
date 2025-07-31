{ pkgs, ... }: {
    home.packages = with pkgs; [
        steam
    ];

    wayland.windowManager.hyprland = {
        enable = true;
        extraConfig = ''
        # Desktop Monitor Config
        monitor=DP-2,1440x2560@60,0x0,1,transform,1
        monitor=HDMI-A-1,2560x1440@120,1440x0,1
        monitor=DP-1,2560x1440@75,3980x0,1
        '';
    };
}