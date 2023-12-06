{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkMerge;

  desktopCfg = config.hopplaos.desktop;
  cfg = desktopCfg.wayland.hyprland;
in {
  options = {
    hopplaos.desktop.wayland.hyprland = {
      enable = mkEnableOption "HopplaOS Wayland";
      nvidia = mkEnableOption "Wayland - Nvidia patches";
    };
  };

  config = mkIf (desktopCfg.enable && cfg.enable) {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      enableNvidiaPatches = cfg.nvidia;
      xwayland.enable = true;
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "";
  };
}
