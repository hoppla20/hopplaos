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

  cfg = config.hopplaos.virtualisation.containers;
in {
  options.hopplaos.virtualisation.containers = {
    enable = mkEnableOption "Docker";
  };

  config = mkIf cfg.enable {
    virtualisation = {
      docker = {
        enable = true;
        rootless = {
          enable = true;
        };
      };
      podman = {
        enable = true;
      };
    };

    environment.systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        skopeo
        docker-compose
        podman-compose
        ;
    };
  };
}
