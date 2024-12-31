{ pkgs, ...}:
{
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      servers = {
	bashls.enable = true;
	clangd.enable = true;
	gopls.enable = true;
	nixd.enable = true;
      };
      keymaps.lspBuf = {

	"gd" = "definition";
	"gD" = "declaration";
	"gr" = "references";
	"gt" = "type_definition";
	"gi" = "implementation";
	"K" = "hover";
	"rn" = "rename";
      };
    };

    rustaceanvim.enable = true;
  };
}
