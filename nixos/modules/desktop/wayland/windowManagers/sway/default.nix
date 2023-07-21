{ pkgs, config, lib, options, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  desktopCfg = config.hopplaos.desktop;
  cfg = desktopCfg.wayland.sway;
in
{
  options = {
    hopplaos.desktop.wayland.sway = {
      enable = mkEnableOption "Wayland - Sway";
    };
  };

  config = mkIf (desktopCfg.enable && cfg.enable) {
    programs.sway = {
      enable = true;
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
      extraSessionCommands = ''
        export SDL_VIDEODRIVER=wayland

        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_THEME_OVERRIDE=adwaita-dark
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1
      '';
    };
  };
}
