{ pkgs, ...}:

{
  imports = [
    ./treesiter.nix
    ./basics.nix
    ./telescope.nix
  ];
}
