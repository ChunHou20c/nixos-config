{ pkgs, ...}:

{
  imports = [
    ./treesiter.nix
    ./basics.nix
    ./telescope.nix
    ./lsp.nix
    ./cmp.nix
    ./rest-nvim.nix
  ];
}
