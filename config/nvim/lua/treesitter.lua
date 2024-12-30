require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
}

vim.filetype.add({extension = {wgsl = "wgsl"}})
-- vim.wo.foldmethod = "expr"
-- vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.o.foldlevelstart = 99 -- do not close folds when a buffer is opened

require("ibl").setup()
