{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkOption
    mkEnableOption
    mkIf
    types
    ;

  desktopCfg = config.hopplaos.desktop;
  cfg = desktopCfg.video-editing;
in {
  options.hopplaos.desktop.video-editing = {
    enable = mkEnableOption "Video Editing";
  };

  config = mkIf (desktopCfg.enable && cfg.enable) {
    home.packages = [pkgs.kdenlive];
  };
}
