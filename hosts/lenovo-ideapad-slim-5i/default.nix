{ pkgs, lib, ... }:

{
  imports = [
    ../../modules/hyprland.nix
    ../../modules/sddm-theme.nix
    ../../modules/systems.nix
  ];

  #bootloader
  boot = {

    bootspec.enable = true;
    loader.systemd-boot.enable = lib.mkForce false;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [ "ntfs" ];
    consoleLogLevel = 3;
    initrd.systemd.enable = true;
    systemd.extraConfig = ''DefaultTimeoutStopSec=6s'';
    systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
    kernelPackages = pkgs.linuxPackages_xanmod_stable;
    # kernelPackages = pkgs.linuxPackages_latest;

    # plymouth : splash screen when booting
    plymouth = {
      enable = true;
      themePackages = [
        (pkgs.adi1090x-plymouth-themes.override  {
          selected_themes = [ "seal_2"  "unrap" ];
        })
      ];
      theme = "unrap";
    };

  };

  # boot.lanzaboote = {
  #   enable = true;
  #   pkiBundle = "/etc/secureboot";
  # };

  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;  # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
  security.tpm2.tctiEnvironment.enable = true;  # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
  networking.hostName = "lenovo-ideapad-slim-i5"; # Define your hostname.

  hardware = {
    opengl.enable = true;
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;

    opengl.extraPackages = with pkgs; [
        intel-media-driver
        vaapiVdpau
        libvdpau-va-gl
      ];
  };

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

}
