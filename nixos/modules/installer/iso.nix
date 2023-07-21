{ pkgs, config, lib, options, ... }:
let
  inherit (lib) mkImageMediaOverride mkEnableOption mkIf;

  cfg = config.hopplaos.installer;
in
{
  options.hopplaos.installer = {
    enable = mkEnableOption "Installer Configuration";
  };

  config = mkIf cfg.enable {
    formatConfigs.custom-iso = { modulesPath, ... }: {
      imports =
        [ "${toString modulesPath}/installer/cd-dvd/installation-cd-base.nix" ];

      boot.kernelPackages =
        mkImageMediaOverride options.boot.kernelPackages.default;
      networking.wireless.enable = mkImageMediaOverride false;

      formatAttr = "isoImage";
      filename = "*.iso";
    };
  };
}
