{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    types
    mkOption
    mkEnableOption
    mkIf
    mkMerge
    ;

  cfg = config.hopplaos.android;
in {
  options.hopplaos.android = {
    enable = mkEnableOption "Android";
  };

  config = mkIf cfg.enable {
    programs.adb.enable = true;
  };
}
