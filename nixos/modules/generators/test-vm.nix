{
  pkgs,
  config,
  lib,
  modulesPath,
  ...
}: let
  cfg = config.hopplaos.generators.test-vm;

  inherit (lib) types mkOption mkEnableOption;
in {
  options = {
    hopplaos.generators.test-vm = {
      headless = mkEnableOption "Test VM headless";
      diskSize = mkOption {
        type = types.int;
        default = 10240;
      };
    };
  };

  config = {
    formatConfigs.vm-bootloader = {config, ...}: {
      virtualisation = {
        cores = 4;
        memorySize = 4096;
        diskSize = cfg.diskSize;
        useEFIBoot = true;
        graphics = !cfg.headless;
        resolution = {
          x = 1280;
          y = 800;
        };
        qemu = {
          guestAgent.enable = true;
          options = [
            # 3d acceleration
            "-device virtio-vga-gl"
            "-display gtk,gl=on"
          ];
        };
      };
    };
  };
}
