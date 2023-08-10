{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) types mkOption mkEnableOption mkIf;

  cfg = config.hopplaos.hardware;
in {
  options.hopplaos.hardware = {
    enable = mkEnableOption "Hardware";

    bluetooth = mkEnableOption "Bluetooth";
    cpu.manufacturer = mkOption {type = types.enum ["intel" "amd"];};
    gpu.manufacturer = mkOption {
      type = types.enum ["intel" "amd" "nvidia"];
    };
  };

  config = mkIf cfg.enable {
    hardware = {
      enableAllFirmware = true;
      cpu.${cfg.cpu.manufacturer}.updateMicrocode = true;
      bluetooth.enable = cfg.bluetooth;
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
    };

    services.fwupd.enable = true;

    environment.systemPackages = [pkgs.gnome-firmware];
  };
}
