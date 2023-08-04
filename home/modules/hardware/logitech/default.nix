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

  cfg = config.hopplaos.hardware.logitech;
in {
  options.hopplaos.hardware.logitech = {
    enable = mkEnableOption "Logitech";
  };

  config = mkIf cfg.enable {
    xdg.configFile = {
      "solaar".source = ./config;
    };
  };
}
