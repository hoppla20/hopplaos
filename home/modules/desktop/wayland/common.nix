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

  gtkSchema = pkgs.gsettings-desktop-schemas;
  gtkDataDir = "${gtkSchema}/share/gsettings-schemas/${gtkSchema.name}";
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
          xwayland
          wl-clipboard
          grim
          slurp
          wdisplays
          ;
      })
      ++ [
        (pkgs.writeShellScriptBin "wl-configure-gtk" ''
          export XDG_DATA_DIRS=${gtkDataDir}:$XDG_DATA_DIRS
          gnome_schema=org.gnome.desktop.interface
          gsettings set $gnome_schema font '${config.gtk.font.name}'
          gsettings set $gnome_schema gtk-theme '${config.gtk.theme.name}'
          gsettings set $gnome_schema icon-theme '${config.gtk.iconTheme.name}'
          gsettings set $gnome_schema cursor-theme '${config.gtk.cursorTheme.name}'
        '')
        (pkgs.writeShellScriptBin "screenshot-select" "mkdir -p ~/Pictures/Screenshots && grim -g \"$(slurp)\" ~/Pictures/Screenshots/$(date -u +\"%Y-%m-%d_%H-%M-%S_grim.png\")")
        (pkgs.writeShellScriptBin "screenshot" "mkdir -p ~/Pictures/Screenshots && grim ~/Pictures/Screenshots/$(date -u +\"%Y-%m-%d_%H-%M-%S_grim.png\")")
        (pkgs.writeShellScriptBin "screenshot-clip" "grim - | wl-copy")
        (pkgs.writeShellScriptBin "screenshot-select-clip" "grim -g \"$(slurp)\" - | wl-copy")
        (pkgs.writeShellScriptBin "screenshot-window-clip" "grim -g \"$(sway-focused-window-geometry)\" - | wl-copy")
      ];
  };
}
