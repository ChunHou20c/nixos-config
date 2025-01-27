{ pkgs, ...}:
{

  programs.nixvim.plugins = {

    lualine.enable = true;
    nvim-tree = {
      openOnSetup = true;
      enable = true;
    };
    lazygit.enable = true;
    gitsigns.enable = true;
    telescope.enable = true;
    floaterm = {
      enable = true;
      width = 0.9;
      height = 0.9;
    };
    indent-blankline.enable = true;
    commentary.enable = true;
    nvim-autopairs.enable = true;
    web-devicons.enable = true;
    friendly-snippets.enable = true;
    copilot-vim.enable = true;

  };

}
