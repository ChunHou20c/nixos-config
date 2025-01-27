{
  home.file.".config/kitty/kitty.conf".source = ./kitty.conf;
  home.file.".config/kitty/current-theme.conf".source = ./current-theme.conf;
  home.file.".config/kitty/scripts" = {
    source = ./scripts;
    recursive = true;
  };
}
