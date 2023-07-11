{
  pkgs,
  config,
  lib,
  self',
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    ;

  desktopCfg = config.hopplaos.desktop;
  cfg = desktopCfg.music;
in {
  options = {
    hopplaos.desktop.music = {
      enable =
        mkEnableOption "HopplaOS Music"
        // {
          default = desktopCfg.enable;
        };
    };
  };

  config = mkIf (desktopCfg.enable && cfg.enable) {
    home.packages = builtins.attrValues {
      inherit
        (pkgs)
        pavucontrol
        playerctl
        spotify
        ;

      inherit
        (self'.packages)
        pulseaudio-control
        ;
    };
  };
}
