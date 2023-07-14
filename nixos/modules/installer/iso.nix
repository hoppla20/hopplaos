{
  pkgs,
  config,
  lib,
  options,
  ...
}: let
  inherit
    (lib)
    mkForce
    ;
in {
  formatConfigs.custom-iso = {
    config,
    modulesPath,
    ...
  }: {
    imports = [
      "${toString modulesPath}/installer/cd-dvd/installation-cd-base.nix"
    ];

    hopplaos.boot.enable = mkForce false;
    boot.kernelPackages = mkForce options.boot.kernelPackages.default;
    networking.wireless.enable = lib.mkImageMediaOverride false;

    disko.devices = mkForce options.disko.devices.default;

    formatAttr = "isoImage";
    filename = "*.iso";
  };
}
