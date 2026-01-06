{pkgs, ...}:
{
  programs.nixvim.diagnostic.settings = {
     virtual_text = true;
  };
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      servers = {
        jdtls.enable = true;
	bashls.enable = true;
	clangd.enable = true;
	pyright.enable = true;
	# pylyzer.enable = true;
	# pylsp.enable = true;

	gopls.enable = true;
	nixd.enable = true;
	phpactor.enable = true;
	# dartls.enable = true;
	kotlin_language_server = {
	  enable = true;
	};
	html = {
	  enable = true;
	  filetypes = ["html"  "php" "njk"];
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
