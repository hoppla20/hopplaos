{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.hopplaos.desktop.hyprland;
in {
  options = {
    hopplaos.desktop.hyprland = {
      enable = mkEnableOption "HopplaOS Wayland";
      nvidia = mkEnableOption "Wayland - Nvidia patches";
    };
  };

  config = mkIf (config.hopplaos.desktop.enable && cfg.enable) {
    programs.hyprland = {
      enable = true;
      nvidiaPatches = cfg.nvidia;
      xwayland = {
        enable = true;
        hidpi = false;
      };
    };
  };
}
