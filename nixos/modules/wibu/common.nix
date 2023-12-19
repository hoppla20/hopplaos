{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption mkEnableOption mkIf mkMerge;

  inherit (pkgs) fetchurl;

  cfg = config.hopplaos.wibu;
in {
  options.hopplaos.wibu = {enable = mkEnableOption "WIBU";};

  config = mkIf cfg.enable {
    hopplaos.virtualisation.vmware-workstation.enable = true;
    security.pki.certificateFiles = lib.filesystem.listFilesRecursive ./certificates;
    services.teamviewer.enable = true;
    environment.systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        zoom-us
        ;
    };
  };
}
