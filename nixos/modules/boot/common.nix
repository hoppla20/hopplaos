{ pkgs, config, lib, ... }:
let
  inherit (lib) types mkOption mkEnableOption mkIf mkMerge;

  cfg = config.hopplaos.boot;
  hardwareCfg = config.hopplaos.hardware;
in {
  options.hopplaos.boot = {
    enable = mkEnableOption "Boot";
    kernelModules.kvm.enable =
      mkEnableOption "Enable kvm-amd or kvm-intel respectively" // {
        default = true;
      };
  };

  config = mkIf cfg.enable {
    boot = {
      kernelModules = mkIf cfg.kernelModules.kvm.enable
        [ "kvm-${hardwareCfg.cpu.manufacturer}" ];
    };
  };
}
