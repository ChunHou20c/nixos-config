set number
set relativenumber
set conceallevel=0
syntax on
filetype indent on
set shiftwidth=2
let mapleader=" "
nnoremap <leader>gg :LazyGit<CR>
nnoremap <leader>l :NvimTreeToggle<CR>
nmap <F6> :TagbarToggle<CR>
source /etc/nixos/config/nvim/vim/floaterm.vim
filetype plugin indent on

colorscheme tokyonight-storm

luafile /etc/nixos/config/nvim/lua/telescope.lua
luafile /etc/nixos/config/nvim/lua/nvimtree.lua
luafile /etc/nixos/config/nvim/lua/treesitter.lua
luafile /etc/nixos/config/nvim/lua/gitsigns.lua
luafile /etc/nixos/config/nvim/lua/lualine.lua
luafile /etc/nixos/config/nvim/lua/lspkind.lua
luafile /etc/nixos/config/nvim/lua/autotag.lua
luafile /etc/nixos/config/nvim/lua/luasnip.lua

lua << EOF
vim.defer_fn(function()
vim.cmd [[
luafile /etc/nixos/config/nvim/lua/lsp.lua
]]
      end, 70)
      EOF
