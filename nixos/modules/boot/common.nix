{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption mkEnableOption mkIf mkMerge;

  cfg = config.hopplaos.boot;
  hardwareCfg = config.hopplaos.hardware;
in {
  options.hopplaos.boot = {
    enable = mkEnableOption "Boot";
    kernelModules.kvm.enable =
      mkEnableOption "Enable kvm-amd or kvm-intel respectively"
      // {
        default = false;
      };
  };

  config = mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf cfg.kernelModules.kvm.enable {
      boot = {
        kernelModules = ["kvm-${hardwareCfg.cpu.manufacturer}"];
        extraModprobeConfig = ''
          options kvm_${hardwareCfg.cpu.manufacturer} nested=1
          options kvm ignore_msrs=1
        '';
      };
    })
  ]);
}
