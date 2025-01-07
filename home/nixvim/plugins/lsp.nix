{pkgs, ...}:
{
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      servers = {
	bashls.enable = true;
	clangd.enable = true;
	gopls.enable = true;
	nixd.enable = true;
	phpactor.enable = true;
	intelephense.enable = true;
	intelephense.package = pkgs.intelephense;
	rust_analyzer = {
	enable = true;
	  installRustc = true;
	  installCargo = true;
	};
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
  };
}
