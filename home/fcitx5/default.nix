{pkgs,...}:
{
  home.file.".local/share/fcitx5/themes" = {
    
    source = "${pkgs.catppuccin-fcitx5}/share/fcitx5/themes";
    recursive = true;
  };

  home.file.".config/fcitx5/conf/classicui.conf".source = ./classicui.conf;
}
