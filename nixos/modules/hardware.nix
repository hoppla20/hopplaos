{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    types
    mkOption
    mkEnableOption
    mkIf
    mkMerge
    ;

  cfg = config.hopplaos.hardware;

  gpuDriversMap = {
    amd = "amdgpu";
    nvidia = "nvidia";
  };
in {
  options.hopplaos.hardware = {
    enable = mkEnableOption "Hardware";

    cpu.manufacturer = mkOption {
      type = types.enum ["intel" "amd"];
    };
    gpu.manufacturer = mkOption {
      type = types.enum ["intel" "amd" "nvidia"];
    };
  };

  config = mkIf cfg.enable {
    boot.initrd.kernelModules = [gpuDriversMap.${cfg.gpu.manufacturer}];
    services.xserver.videoDrivers = [gpuDriversMap.${cfg.gpu.manufacturer}];

    hardware = {
      enableRedistributableFirmware = true;
      opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };
      cpu.amd.updateMicrocode = true;
    };
  };
}
