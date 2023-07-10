{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.hopplaos.generators.test-vm;

  inherit
    (lib)
    mkEnableOption
    ;
in {
  options = {
    hopplaos.generators.test-vm = {
      headlessMode = mkEnableOption "Test VM - headless mode";
      useEfiBoot = mkEnableOption "Test VM - efi boot" // {default = true;};
    };
  };

  config = {
    formatConfigs.vm-bootloader = {config, ...}: {
      virtualisation = {
        cores = 2;
        memorySize = 2048;
        diskSize = 10240;
        graphics = ! cfg.headlessMode;
        useEFIBoot = cfg.useEfiBoot;
      };
    };
  };
}
