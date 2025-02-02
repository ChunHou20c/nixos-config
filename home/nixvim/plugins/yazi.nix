{ pkgs, ...}:
{

  programs.nixvim.plugins = {

    yazi = {
      enable = true;
    };

  };
}
