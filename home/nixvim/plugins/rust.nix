{ pkgs, ...}:
{
  programs.nixvim = {

    # Runtime cargo-feature switching for rust-analyzer. Kept in a real .lua file
    # so it gets proper treesitter/LSP support; extraConfigLuaPost guarantees it
    # runs after nixvim's LSP block has called vim.lsp.config("rust_analyzer", ...).
    extraConfigLuaPost = builtins.readFile ./rust-features.lua;

    keymaps = [
      {
        mode = "n";
        key = "<leader>rf";
        options = {
          silent = true;
          desc = "rust-analyzer: switch cargo features";
        };
        action = "<cmd>RustFeatures<CR>";
      }
    ];
  };
}
