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

  cfg = config.hopplaos.virtualisation.vmware-workstation;
in {
  options.hopplaos.virtualisation.vmware-workstation = {
    enable = mkEnableOption "VMWare Workstation";
  };

  config = mkIf cfg.enable {
    virtualisation.vmware.host.enable = true;
    boot = {
      kernelParams = [
        # https://bbs.archlinux.org/viewtopic.php?id=277282
        "ibt=off"
        # https://github.com/NixOS/nixpkgs/blob/4cdad15f34e6321a2f789b99d42815b9142ac2ba/nixos/modules/virtualisation/vmware-host.nix#L30
        "transparent_hugepages=never"
      ];
    };
  };
}
