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
  cfg = desktopCfg.image-editing;
in {
  options.hopplaos.desktop.image-editing = {
    enable = mkEnableOption "Image Editing";
  };

  config = mkIf (desktopCfg.enable && cfg.enable) {
    home.packages = [pkgs.gimp];
  };
}
