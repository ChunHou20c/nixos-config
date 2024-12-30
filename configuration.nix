# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let
    sources = import ./nix/sources.nix;
    lanzaboote = import sources.lanzaboote;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./unstable-packages.nix
      ./cachix.nix
      <home-manager/nixos>
      lanzaboote.nixosModules.lanzaboote
    ];

  # Boot
  boot.bootspec.enable = true;
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.consoleLogLevel = 3;


  networking.extraHosts =
  ''
    192.168.56.101 earth.local terratest.earth.local
  '';

  # boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.initrd.systemd.enable = true;
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=6s
  '';
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  # boot.kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_xanmod_stable.override { argsOverride = { version = "6.4.15"; }; });
  boot.kernelPackages = pkgs.linuxPackages_xanmod_stable;
  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.plymouth = {
    enable = true;
    themePackages = [
    (pkgs.adi1090x-plymouth-themes.override  {
    selected_themes = [ "seal_2"  "unrap" ];
    })
    ];
    theme = "unrap";
  };

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;  # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
  security.tpm2.tctiEnvironment.enable = true;  # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
 # networking.nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];

 # services.resolved = {
 #   enable = true;
 #   dnssec = "true";
 #   domains = [ "~." ];
 #   fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
 #   extraConfig = ''
 #   DNSOverTLS=yes
 #   '';
 # };

  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.extraOptions = ''
  keep-outputs = true
  keep-derivations = true
  '';
  security.pam.services.swaylock = {};

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  programs.light.enable = true;
  programs.seahorse.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kuala_Lumpur";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ms_MY.UTF-8";
    LC_IDENTIFICATION = "ms_MY.UTF-8";
    LC_MEASUREMENT = "ms_MY.UTF-8";
    LC_MONETARY = "ms_MY.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "ms_MY.UTF-8";
    LC_PAPER = "ms_MY.UTF-8";
    LC_TELEPHONE = "ms_MY.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  i18n.inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
          # fcitx5-mozc
          fcitx5-gtk
          fcitx5-chinese-addons
	  fcitx5-rime
          libsForQt5.fcitx5-qt

      ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "intel" ];
  #services.twingate.enable = true;
  services.displayManager.sddm = {
    enable = true;
    theme = "${import ./sddm-theme.nix { inherit pkgs;}}";
  };
  # services.xserver.desktopManager.gnome.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # Enable hyprland
  programs.hyprland ={
    enable = true;
    xwayland.enable = true;
  };

  programs.thunar.enable = true;
  programs.openvpn3.enable = true;
  programs.steam.enable = true;
  # programs.steam.package = pkgs.old-packages.steam;
  
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  services.tumbler.enable = true;

  xdg.portal.enable = true;
  # xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal];
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-hyprland pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland];

  environment.sessionVariables = {
  NIXOS_OZONE_WL = "1";
  GTK_USE_PORTAL = "1";
  NIXOS_XDG_OPEN_USE_PORTAL = "1";
  WLR_NO_HARDWARE_CURSORS = "1";
  };

  programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [

    # Add any missing dynamic libraries for unpackaged programs

    # here, NOT in environment.systemPackages

  ];



  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing ={
    enable = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  hardware = {
    opengl.enable = true;
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;

    opengl.extraPackages = with pkgs; [
        intel-media-driver
        vaapiVdpau
        libvdpau-va-gl
        intel-ocl
        intel-gmmlib
        intel-compute-runtime
      ];
    bluetooth.enable = true;

  };

  services.httpd = {
    enable = true;
    enablePHP = true;
    virtualHosts."_" = {
      documentRoot = "/var/wwwrun/dev";
      listen = [
        {
          ip = "127.0.0.1";
          port = 80;
        }
      ];
    };
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.chunhou = {
    isNormalUser = true;
    description = "chunhou";
    extraGroups = [ "networkmanager" "wheel"  "libvirtd" "tss" "video"];

      packages = with pkgs; [
    
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
        mysql-workbench
        conda
      ];
    };
  home-manager.users.chunhou = { pkgs, ... }: {

    home.stateVersion = "24.05";
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

  };
  
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    configure = {
    customRC = ''
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
      '';
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ 

          # comment out lines
          vim-commentary
          # floating terminal
          vim-floaterm

          gitsigns-nvim
          vim-nix
          indent-blankline-nvim
          nvim-treesitter-parsers.wgsl
          nvim-treesitter-parsers.wgsl_bevy

          # eye candy
	  nvim-treesitter.withAllGrammars
          lualine-nvim

          # for file explorer
	  nvim-tree-lua
          nvim-web-devicons

          # for extra themes
          tokyonight-nvim
          
          # lazygit
          lazygit-nvim

          # lsp
          nvim-lspconfig
          nvim-cmp
          cmp-nvim-lsp
          luasnip
          cmp-nvim-lsp-signature-help
          cmp_luasnip
          friendly-snippets
          lspkind-nvim

          # telescope
          telescope-nvim

          # profiling
          vim-startuptime

          # tagbar
          tagbar

          # autopair and autotag
          nvim-ts-autotag
          nvim-autopairs
          autoclose-nvim
          nvim-surround
          # rest-nvim
          plenary-nvim
        ];
      }; 
    };
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "chunhou" ];
  programs.dconf.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
                "electron-25.8.6"
                "electron-25.9.0"
              ];
  nixpkgs.config.packageOverrides = pkgs: rec {
    wpa_supplicant = pkgs.wpa_supplicant.overrideAttrs (attrs: {
      patches = attrs.patches ++ [ ./eduroam.patch ];
    });
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };

    old-packages = import (builtins.fetchTarball {
    # Descriptive name to make the store path easier to identify
    name = "nixos-23.11";
    # Commit hash for nixos-unstable as of 2018-09-12
    url = "https://github.com/nixos/nixpkgs/archive/d234709da542fda31e3106c595e27be4d3e8e572.tar.gz";
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    sha256 = "sha256:0j0i13b3l8cvkwrjlcfmxh6g0n7yzijr3h4bliqzi7c18mr97wkf";
  }){ 
    config = {
      allowUnfree = true;
    };
  };
  };


  virtualisation.spiceUSBRedirection.enable = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # nixpkgs.overlays = [
  #   (self: super: {
  #     waybar = super.waybar.overrideAttrs (oldAttrs: {
  #       mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
  #       patches = (oldAttrs.rpatches or []) ++ [
  #         (pkgs.fetchpatch {
  #           name = "fix waybar hyprctl";
  #           url = "https://aur.archlinux.org/cgit/aur.git/plain/hyprctl.patch?h=waybar-hyprland-git";
  #           sha256 = "sha256-pY3+9Dhi61Jo2cPnBdmn3NUTSA8bAbtgsk2ooj4y7aQ=";
  #         })
  #       ];
  #     });
  #   })
  # ];

  environment.systemPackages = with pkgs; [

    gnome.nautilus
    xfce.thunar
    php
    phpactor
    # for tidying html output
    html-tidy
    tpm2-tss

    # for neovim tagbar
    universal-ctags

    niv
    sbctl
    vim
    wget
    btop
    kitty
    alacritty
    st
    btop
    htop
    neofetch
    virt-manager
    xdg-desktop-portal-hyprland
    xdg-utils
    gnome.gnome-keyring
    gnome.file-roller
    gnome.adwaita-icon-theme
    gnome.gnome-themes-extra
    ubuntu_font_family
    zip
    unzip
    spice-gtk
    firefox
    firefox-devedition

    aseprite
    ldtk

    wdisplays

    networkmanagerapplet
    waybar
    eww
    dunst
    libnotify
    swww

    lz4

    wofi
    ntfs3g
    imv
    eza

    #for eww bar
    python310
    ruby
    jq
    socat 

    wireguard-tools
    swaylock-effects
    swaylock
    swayidle
    distrobox
    podman
    copyq
    networkmanager-openvpn
    sway-contrib.grimshot
    zellij
    tmux
    vscodium
    pamixer
    lutris  
    gamemode
    gamescope

    ffmpeg

    # clipboard for wayland
    wl-clipboard

    # support both 32- and 64-bit applications
    wineWowPackages.stable

    # winetricks (all versions)
    winetricks

    # native wayland support (unstable)
    wineWowPackages.waylandFull
    git
    pavucontrol
    rustup

    # language server
    nil
    tailwindcss-language-server
    nodePackages.pyright
    nodePackages.intelephense
    nodePackages.typescript-language-server
    nodePackages.vls
    nodePackages.volar

    lua-language-server
    libclang

    # c compiler
    clang

    # fuzzy finders
    ripgrep
    fd

    tree-sitter
    nodejs_20

    # security scanner
    chkrootkit
    clamav

    # for sddm
    libsForQt5.qt5.qtquickcontrols2   
    libsForQt5.qt5.qtgraphicaleffects

    # for pdf editor
    xournalpp
    remmina

    rpi-imager
  ];

  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [  
	  nerdfonts
	  font-awesome
	  google-fonts
          vistafonts
          corefonts
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  programs.gamemode.enable = true;

  services.flatpak.enable = true;
  services.blueman.enable = true;
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_BAT="powersave";
      CPU_SCALING_GOVERNOR_ON_AC="performance";

      # The following prevents the battery from charging fully to
      # preserve lifetime. Run `tlp fullcharge` to temporarily force
      # full charge.
      # https://linrunner.de/tlp/faq/battery.html#how-to-choose-good-battery-charge-thresholds
      START_CHARGE_THRESH_BAT0=55;
      STOP_CHARGE_THRESH_BAT0="1";

      # 100 being the maximum, limit the speed of my CPU to reduce
      # heat and increase battery usage:
      CPU_MAX_PERF_ON_AC=100;
      CPU_MAX_PERF_ON_BAT=75;
    };
  };

  virtualisation.podman.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 3005 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  system.stateVersion = "23.05"; # Did you read the comment?

}
