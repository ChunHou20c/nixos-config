{ pkgs, ... }: {

  environment.systemPackages = with pkgs; [

    nil
    tailwindcss-language-server
    nodePackages.pyright
    nodePackages.intelephense
    nodePackages.typescript-language-server
    nodePackages.vls
    nodePackages.volar

    lua-language-server
    libclang

    tree-sitter
  ];
}
