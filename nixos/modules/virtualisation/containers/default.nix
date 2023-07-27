{
  pkgs,
  unstable,
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

  cfg = config.hopplaos.virtualisation.containers;
in {
  options.hopplaos.virtualisation.containers = {
    enable = mkEnableOption "Docker";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      docker = {
        enable = true;
        package = unstable.docker;
      };
      podman = {
        enable = true;
        package = unstable.podman;
      };
    };
  };
}
