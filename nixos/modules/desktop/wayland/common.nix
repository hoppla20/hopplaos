{
  pkgs,
  config,
  lib,
  self,
  ...
}: let
  inherit
    (builtins)
    attrNames
    attrValues
    pathExists
    readDir
    any
    ;
  inherit
    (lib)
    filterAttrs
    mkIf
    mkEnableOption
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

  config = mkIf cfg.enable {
    environment.systemPackages = attrValues {
      inherit
        (pkgs)
        polkit_gnome
        ;
      inherit (pkgs.qt6) qtwayland;
    };
  };
}
