{
  pkgs,
  config,
  lib,
  self,
  ...
}: let
  inherit
    (builtins)
    readDir
    pathExists
    attrNames
    attrValues
    isNull
    any
    ;
  inherit
    (lib)
    mkIf
    mkEnableOption
    filterAttrs
    findFirst
    ;
  inherit
    (self.lib)
    listDirectoryModules
    ;

  desktopCfg = config.hopplaos.desktop;
  cfg = desktopCfg.wayland;

  wms = attrNames (listDirectoryModules ./windowManagers);
in {
  options = {
    hopplaos.desktop.wayland.enable =
      mkEnableOption "Wayland"
      // {
        readOnly = true;
        default = any (wm: cfg.${wm}.enable) wms;
      };
  };

  config = mkIf (desktopCfg.enable && cfg.enable) {
    home.packages =
      (attrValues {
        inherit
          (pkgs)
          wl-clipboard
          grim
          slurp
          ;

        inherit
          (pkgs.xorg)
          xhost
          ;
      })
      ++ [
        (pkgs.writeShellScriptBin "screenshot-select" "mkdir -p ~/Pictures/Screenshots && grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date -u +\"%Y-%m-%d_%H-%M-%S_grim.png\")")
        (pkgs.writeShellScriptBin "screenshot" "mkdir -p ~/Pictures/Screenshots && grim ~/Pictures/Screenshots/$(date -u +\"%Y-%m-%d_%H-%M-%S_grim.png\")")
        (pkgs.writeShellScriptBin "screenshot-clip" "grim - | wl-copy")
        (pkgs.writeShellScriptBin "screenshot-select-clip" "grim -g \"$(slurp)\" - | wl-copy")
        (pkgs.writeShellScriptBin "screenshot-window-clip" "grim -g \"$(sway-focused-window-geometry)\" - | wl-copy")
      ];
  };
}
