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
	html = {
	  enable = true;
	  filetypes = ["html"  "php"];
	};
	volar.enable = true;
	ts_ls.enable = true;
	nil_ls.enable = true;
	volar.tslsIntegration = false;
	rust_analyzer = {
	  enable = true;
	  installRustc = false;
	  installCargo = false;
	  settings = {
	    checkOnSave = false;
	  };
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
