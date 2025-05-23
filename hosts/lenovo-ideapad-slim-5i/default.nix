{ pkgs, lib, ... }:

{
  imports = [
    ../../modules/hyprland.nix
    ../../modules/systems.nix
    ../../modules/gaming.nix
    ../../modules/media.nix
    ./hardware-configuration.nix
  ];

  services.mysql = {
    enable = true;
    package = pkgs.mysql84;
    settings = {
      mysqld.plugin-load-add = [ "mysql_native_password" "ed25519=auth_ed25519" ];
      mysqld.mysql_native_password = "ON";
    };
  };

  services.logind.extraConfig = ''
  HandlePowerKey=ignore
  '';
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  #bootloader
  boot = {

    bootspec.enable = true;
    loader.systemd-boot.enable = lib.mkForce false;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [ "ntfs" ];
    consoleLogLevel = 3;
    initrd.systemd.enable = true;
    # systemd.extraConfig = ''DefaultTimeoutStopSec=6s'';
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

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "modesetting" ];

  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;  # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
  security.tpm2.tctiEnvironment.enable = true;  # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
  networking.hostName = "nixos"; # Define your hostname.

  hardware = {
    graphics.enable = true;
    graphics.enable32Bit = true;

    graphics.extraPackages = with pkgs; [
        intel-media-driver
        vaapiVdpau
        libvdpau-va-gl
	vpl-gpu-rt
      ];
    bluetooth.enable = true;
    sane.enable = true;
    sane.extraBackends = [ pkgs.hplipWithPlugin ];
  };

  hardware.firmware = [
    (
      let
        model = "37xx";
        version = "0.0";

        firmware = pkgs.fetchurl {
          url = "https://github.com/intel/linux-npu-driver/raw/v1.2.0/firmware/bin/vpu_${model}_v${version}.bin";
          hash = "sha256-qGhLLiBnOlmF/BEIGC7DEPjfgdLCaMe7mWEtM9uK1mo=";
        };
      in
      pkgs.runCommand "intel-vpu-firmware-${model}-${version}" { } ''
        mkdir -p "$out/lib/firmware/intel/vpu"
        cp '${firmware}' "$out/lib/firmware/intel/vpu/vpu_${model}_v${version}.bin"
      ''
    )
  ];

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
