{ pkgs, config, lib, inputs, ... }:
let
  inherit (lib) types mkOption mkEnableOption mkIf;

  cfg = config.hopplaos.hardware;
in
{
  options.hopplaos.hardware = {
    enable = mkEnableOption "Hardware";

    bluetooth = mkEnableOption "Bluetooth";
    cpu.manufacturer = mkOption { type = types.enum [ "intel" "amd" ]; };
    gpu.manufacturer =
      mkOption { type = types.enum [ "intel" "amd" "nvidia" ]; };
  };

  config = mkIf cfg.enable {
    hardware = {
      bluetooth.enable = cfg.bluetooth;
      enableRedistributableFirmware = true;
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
    };
  };
}