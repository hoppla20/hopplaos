# https://wiki.archlinux.org/title/Hardware_video_acceleration#Configuring_VA-API
# https://nixos.wiki/wiki/Accelerated_Video_Playback
{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) types mkOption mkEnableOption mkIf mkMerge;

  cfg = config.hopplaos.hardware;
in {
  options.hopplaos.hardware = {
    enable = mkEnableOption "Hardware";

    bluetooth = mkEnableOption "Bluetooth" // {default = true;};
    cpu.manufacturer = mkOption {type = types.enum ["intel" "amd"];};
    gpu.manufacturer = mkOption {
      type = types.enum ["intel" "amd" "nvidia"];
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
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

      environment = {
        systemPackages = [pkgs.gnome-firmware];
      };
    }
    (mkIf (cfg.gpu.manufacturer == "intel") {
      hardware.opengl.extraPackages = [
        pkgs.intel-media-driver
      ];
      environment.variables = {
        LIBVA_DRIVER_NAME = "iHD";
      };
    })
    (mkIf (cfg.gpu.manufacturer == "amd") {
      environment.variables = {
        LIBVA_DRIVER_NAME = "radeonsi";
      };
    })
  ]);
}
