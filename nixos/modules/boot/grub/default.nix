{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkOption
    mkEnableOption
    mkIf
    mkMerge
    ;

  cfg = config.hopplaos.boot.grub;
  bootCfg = config.hopplaos.boot;
in {
  options.hopplaos.boot.grub = {
    enable = mkEnableOption "Grub";
    osProber = mkEnableOption "OS Prober";
    vmConfig = mkEnableOption "VM Config for Grub";
  };

  config = mkIf (bootCfg.enable && cfg.enable) {
    boot.loader = {
      efi.canTouchEfiVariables = ! cfg.vmConfig;
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = cfg.vmConfig;
        device = "nodev";
        useOSProber = cfg.osProber;
      };
    };
  };
}
