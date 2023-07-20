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
    security.pki.certificateFiles = lib.filesystem.listFilesRecursive ./certificates;

    environment.systemPackages = [pkgs.vmware-workstation];
  };
}
