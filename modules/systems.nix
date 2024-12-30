{ pkgs, username, ... }:
{

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel"  "libvirtd" "tss" "video"];
  };

  nix.settings.trusted-users = [username];

  services.displayManager.sddm = {
    enable = true;
    theme = "${import ./sddm-theme.nix { inherit pkgs;}}";
  };

  nixpkgs.config.allowUnfree = true;

  services.gnome.gnome-keyring.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.extraOptions = ''
  keep-outputs = true
  keep-derivations = true
  '';
  security.pam.services.swaylock = {};

  # Enable networking
  networking.networkmanager.enable = true;
  programs.light.enable = true;
  # time zone.
  time.timeZone = "Asia/Kuala_Lumpur";

  # internationalisation properties.
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

  # appimage runner
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

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

  bluetooth.enable = true;

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

  services.blueman.enable = true;
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  virtualisation.podman.enable = true;

  environment.systemPackages = with pkgs; [

    tpm2-tss
    xfce.thunar
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
    socat 

    # for neovim tagbar
    universal-ctags

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
    swaylock-effects
    swaylock
    swayidle


    wireguard-tools
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


}
