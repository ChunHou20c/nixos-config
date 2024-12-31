{ pkgs, ...}:
{

  imports = [
    ./plugins
    ./keymaps.nix
  ];
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    opts = {
      number = true;         # Show line numbers
	relativenumber = true; # Show relative line numbers
	shiftwidth = 2;        # Tab width should be 2
    };

    colorschemes.tokyonight = {
      enable = true;
      settings.style = "storm";
    };
  };
}
