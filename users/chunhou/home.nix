{pkgs, nixvim, ...}: {
  ##################################################################################################################
  #
  # All ChunHou's Home Manager Configuration
  #
  ##################################################################################################################

  imports = [
    ../../home/core.nix
    ../../home/hyprland
    nixvim.homeManagerModules.nixvim
  ];

  programs.git = {
    userName = "ChunHou20c";
    userEmail = "chunhouthatbornin20c@gmail.com";
  };

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    opts = {
      number = true;         # Show line numbers
      relativenumber = true; # Show relative line numbers
      shiftwidth = 2;        # Tab width should be 2
    };
    globals.mapleader = " ";
    colorschemes.tokyonight = {
    enable = true;
    settings.style = "storm";
    };

    plugins = {

      treesitter = {
	enable = true;

	grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
	  bash
	  json
	  lua
	  make
	  markdown
	  nix
	  regex
	  toml
	  vim
	  vimdoc
	  xml
	  yaml
	  rust
	  python
	];
      };
      lualine.enable = true;
      nvim-tree = {
      openOnSetup = true;
      enable = true;
      };
      lazygit.enable = true;
      gitsigns.enable = true;
      telescope.enable = true;
      floaterm = {
      enable = true;
      width = 0.9;
      height = 0.9;
      };
      indent-blankline.enable = true;
      commentary.enable = true;
    };

    keymaps = [
    {
      mode = "n";
      key = "<leader>l";
      options.silent = true;
      action = ":NvimTreeToggle<CR>";
    }
    {
      mode = "n";
      key = "<leader>gg";
      options.silent = true;
      action = ":LazyGit<CR>";
    }
    {

      mode = "n";
      key = "<F12>";
      options.silent = true;
      action = ":FloatermToggle<CR>";
    }
    {

      mode = "t";
      key = "<F12>";
      options.silent = true;
      action = "<C-\\><C-n>:FloatermToggle<CR>";
    }
    ];
  };

  home.packages = with pkgs; [

    ferdium
    lazygit
    libreoffice-fresh
    starship
    evince
    mpv
    gnome.vinagre
    google-chrome
    bottles
    obs-studio
    obsidian
    obs-studio-plugins.wlrobs
    gimp
    mysql
  ];

  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "Tokyonight-Storm-B";
    style.package = pkgs.tokyo-night-gtk;
  };

  gtk = {

    enable = true;
      # iconTheme.package = pkgs.nordzy-icon-theme;
      iconTheme.package = pkgs.papirus-icon-theme;
      iconTheme.name = "Papirus-Dark";

      theme.package = pkgs.tokyo-night-gtk;
      theme.name = "Tokyonight-Storm-B";

    };

}
