{ pkgs, ... }: {

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
