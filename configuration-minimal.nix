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
      ./cachix.nix
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
          qt6Packages.fcitx5-chinese-addons
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
    opengl.driSupport32Bit = true;
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
    extraGroups = [ "networkmanager" "wheel"  "libvirtd" "tss" "video" "dialout"];

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
          # lsp
        ];
      }; 
    };
  };

  programs.dconf.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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

    xfce.thunar
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
    ubuntu-classic
    zip
    unzip



    # language server
    # security scanner
  ];

  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [  
	  nerdfonts
	  font-awesome
	  google-fonts
          vista-fonts
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

  system.stateVersion = "24.11"; # Did you read the comment?

}
