{ pkgs, ...}:
{

  programs.nixvim = {

    globals.mapleader = " ";

    keymaps = [
    {
      mode = "n";
      key = "<leader>l";
      options.silent = true;
      action = ":NvimTreeToggle<CR>";
    }
    {
      mode = "n";
      key = "<leader>gg";
      options.silent = true;
      action = ":LazyGit<CR>";
    }
    {

      mode = "n";
      key = "<F12>";
      options.silent = true;
      action = ":FloatermToggle<CR>";
    }
    {

      mode = "t";
      key = "<F12>";
      options.silent = true;
      action = "<C-\\><C-n>:FloatermToggle<CR>";
    }
    ];
  };
}
