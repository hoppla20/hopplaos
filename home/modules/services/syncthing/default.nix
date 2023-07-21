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

  cfg = config.hopplaos.services.syncthing;
in {
  options.hopplaos.services.syncthing = {
    enable = mkEnableOption "Syncthing";
  };

  config = mkIf cfg.enable {
    services.syncthing.enable = true;
    systemd.user.services.syncthing.Unit.Requires = ["tray.target"];
  };
}
