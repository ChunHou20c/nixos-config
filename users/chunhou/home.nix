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
    ../../home/eww
    ../../home/swaylock
    ../../home/starship
    ../../home/kitty
    ../../home/fcitx5
    nixvim.homeManagerModules.nixvim
  ];

  programs.git = {
    enable = true;
    userName = "ChunHou20c";
    userEmail = "chunhouthatbornin20c@gmail.com";
  };

  programs.bash = {

    enable = true;
    bashrcExtra = ''
      eval "$(starship init bash)"
      alias ls="exa"
      export PATH="$HOME/.local/bin:$HOME/.npm-packages/bin:$PATH"
    '';
  };

  xdg = {
    enable = true;
    userDirs.createDirectories = true;
    userDirs.enable = true;
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
    obsidian
    mariadb
    redis
  ];

   programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      defaultOptions = [
        "--info=inline"
        "--border=rounded"
        "--margin=1"
        "--padding=1" 
	"--layout=reverse"
      ];
   };

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "Tokyonight-Dark";
    style.package = pkgs.tokyonight-gtk-theme;
  };

  gtk = {

    enable = true;
      # iconTheme.package = pkgs.nordzy-icon-theme;
      iconTheme.package = pkgs.papirus-icon-theme;
      iconTheme.name = "Papirus-Dark";

      theme.package = pkgs.tokyonight-gtk-theme;
      theme.name = "Tokyonight-Dark";

      cursorTheme.name = "capitaine-cursors";
      cursorTheme.package = pkgs.capitaine-cursors;
    };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

}
