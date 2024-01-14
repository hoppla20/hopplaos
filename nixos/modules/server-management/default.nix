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

  cfg = config.hopplaos.server-management;
in {
  options.hopplaos.server-management = {
    enable = mkEnableOption "Server Management Tools";
  };

  config = mkIf cfg.enable {
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };
  };
}
