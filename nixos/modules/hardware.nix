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

  cfg = config.hopplaos.hardware;
in {
  options.hopplaos.hardware = {
    enable = mkEnableOption "Hardware";

    cpu.manufacturer = mkOption {
      type = types.enum ["intel" "amd"];
    };
    gpu.manufacturer = mkOption {
      type = types.enum ["intel" "amd" "nvidia"];
    };
  };
}
