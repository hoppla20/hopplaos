{
  pkgs,
  config,
  lib,
  options,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;

  cfg = config.hopplaos.desktop.sway;
in {
  options = {
    hopplaos.desktop.sway = {
      enable = mkEnableOption "Wayland - Sway";
    };
  };

  config = mkIf (config.hopplaos.desktop.enable && cfg.enable) {
    programs.sway = {
      enable = true;
      wrapperFeatures = {
        base = true;
        gtk = true;
      };
      extraSessionCommands = ''
        export WLR_NO_HARDWARE_CURSORS=1

        export MOZ_ENABLE_WAYLAND=1;
        export MOZ_USE_XINPUT2=1;

        export SDL_VIDEODRIVER=wayland

        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        export QT_THEME_OVERRIDE=adwaita-dark

        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1
      '';
    };
  };
}
