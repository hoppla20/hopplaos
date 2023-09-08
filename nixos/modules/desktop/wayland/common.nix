{
  pkgs,
  config,
  lib,
  self,
  ...
}: let
  inherit (builtins) attrNames attrValues pathExists readDir any;
  inherit (lib) filterAttrs mkIf mkEnableOption findFirst;
  inherit (self.lib) listDirectoryModules;

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
    security.pam.services.swaylock = {};
    environment.systemPackages = [
      pkgs.polkit_gnome
      pkgs.qt5.qtwayland
      pkgs.qt6.qtwayland
    ];
    xdg.portal.extraPortals = lib.mkOrder 2000 [pkgs.xdg-desktop-portal-gtk];
  };
}
