{ pkgs, config, lib, ... }:
let
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
      nvidiaPatches = cfg.nvidia;
      xwayland = {
        enable = true;
        hidpi = false;
      };
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "";
  };
}
