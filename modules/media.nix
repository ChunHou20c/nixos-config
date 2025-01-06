{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [

    #fcitx5 theming
    
    obs-studio-plugins.wlrobs
    obs-studio
    ];
}
