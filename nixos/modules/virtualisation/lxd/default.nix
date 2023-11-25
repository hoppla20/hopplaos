{
  pkgs,
  pkgs-unstable,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.hopplaos.virtualisation.lxd;
in {
  disabledModules = ["virtualisation/lxd.nix"];

  imports = [
    "${inputs.unstable}/nixos/modules/virtualisation/lxd.nix"
  ];

  options.hopplaos.virtualisation.lxd = {
    enable = lib.mkEnableOption "Lxd";
  };

  config = lib.mkIf cfg.enable {
    virtualisation = {
      lxd = {
        enable = true;
        recommendedSysctlSettings = true;
      };
      lxc = {
        enable = true;
        lxcfs.enable = true;
      };
    };
  };
}
