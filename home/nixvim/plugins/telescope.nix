{ pkgs, ...}:
{

  programs.nixvim.plugins = {

    telescope = {
      enable = true;
      keymaps = {

      "<leader>fg" = "live_grep";
      "<leader>ff" = "find_files";
      "<leader>fb" = "find_buffers";
      "<leader>fh" = "help_tags";
      };
    };
  };

}
