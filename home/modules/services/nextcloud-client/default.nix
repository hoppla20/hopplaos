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

  cfg = config.hopplaos.services.nextcloud-client;
in {
  options.hopplaos.services.nextcloud-client = {
    enable = mkEnableOption "Nextcloud Client";
  };

  config = mkIf cfg.enable {
    services.nextcloud-client = {
      enable = true;
      startInBackground = true;
    };

    systemd.user.services.nextcloud-client.Unit.Requires = ["tray.target"];
  };
}
