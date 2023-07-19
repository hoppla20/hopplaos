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

  cfg = config.hopplaos.wibu;
in {
  options.hopplaos.wibu = {
    enable = mkEnableOption "WIBU";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.vmware-workstation];
  };
}
