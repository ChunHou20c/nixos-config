{pkgs, nixvim, ...}: {
  ##################################################################################################################
  #
  # All ChunHou's Home Manager Configuration
  #
  ##################################################################################################################

  imports = [
    ../../home/core.nix
    ../../home/hyprland
    ../../home/pictures
    ../../home/nixvim
    ../../home/waybar
    ../../home/swaylock
    nixvim.homeManagerModules.nixvim
  ];

  programs.git = {
    userName = "ChunHou20c";
    userEmail = "chunhouthatbornin20c@gmail.com";
  };


  home.packages = with pkgs; [

    ferdium
    lazygit
    libreoffice-fresh
    starship
    evince
    mpv
    remmina
    google-chrome
    bottles
    obs-studio
    obsidian
    obs-studio-plugins.wlrobs
    gimp
    mariadb
    osu-lazer-bin
  ];

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "Tokyonight-Storm-B";
    style.package = pkgs.tokyo-night-gtk;
  };

  gtk = {

    enable = true;
      # iconTheme.package = pkgs.nordzy-icon-theme;
      iconTheme.package = pkgs.papirus-icon-theme;
      iconTheme.name = "Papirus-Dark";

      theme.package = pkgs.tokyo-night-gtk;
      theme.name = "Tokyonight-Storm-B";

    };

}
