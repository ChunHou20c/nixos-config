{pkgs, ...}: {
  ##################################################################################################################
  #
  # All ChunHou's Home Manager Configuration
  #
  ##################################################################################################################

  imports = [
    ../../home/core.nix
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
