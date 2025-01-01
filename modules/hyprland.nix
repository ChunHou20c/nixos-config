{ pkgs, ... }:
{
  programs.hyprland ={
    enable = true;
    xwayland.enable = true;
  };

  programs.thunar.enable = true;
  
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  services.tumbler.enable = true;

  xdg.portal.enable = true;
  # xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal];
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland];

  environment.sessionVariables = {
  NIXOS_OZONE_WL = "1";
  GTK_USE_PORTAL = "1";
  NIXOS_XDG_OPEN_USE_PORTAL = "1";
  WLR_NO_HARDWARE_CURSORS = "1";
  };

  environment.systemPackages = with pkgs; [

    networkmanagerapplet
    waybar
    eww
    dunst
    libnotify
    swww

    lz4

    wofi
    ntfs3g
    imv
    copyq

    #for eww bar
    python310
    ruby
    jq
    swaylock-effects
    swaylock
    swayidle
    sway-contrib.grimshot

    # clipboard for wayland
    wl-clipboard
    pavucontrol
    pamixer
  ];

}
