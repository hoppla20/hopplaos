{ pkgs, config, lib, ... }:
let
  inherit (lib) types mkOption mkEnableOption mkIf mkMerge;

  cfg = config.hopplaos.profiles.desktop;
in {
  options.hopplaos.profiles.desktop = mkEnableOption "Desktop Profile";

  config = mkIf cfg {
    hopplaos = {
      boot = {
        enable = true;
        kernelModules.kvm.enable = true;
        grub.enable = true;
        plymouth.enable = true;
      };
      desktop = {
        enable = true;
        thunar.enable = true;
        wayland.hyprland.enable = true;
      };
    };
  };
}