{pkgs, ...}: {
  ##################################################################################################################
  #
  # All ChunHou's Home Manager Configuration
  #
  ##################################################################################################################

  imports = [
    ../../home/core.nix
    ../../home/hyprland
    ../../home/nvim
    ../../home/dev-tools
  ];

  programs.git = {
    userName = "ChunHou20c";
    userEmail = "chunhouthatbornin20c@gmail.com";
  };

  packages = with pkgs; [

    ferdium
    lazygit
    libreoffice-fresh
    starship
    evince
    mpv
    gnome.vinagre
    google-chrome
    bottles
    obs-studio
    obsidian
    obs-studio-plugins.wlrobs
    gimp
    mysql
  ];
}
