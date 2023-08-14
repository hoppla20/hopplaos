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

  cfg = config.hopplaos.programs.email;
in {
  options.hopplaos.programs.email = {
    enable = mkEnableOption "Thunderbird";
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.thunderbird pkgs.evolution];
  };
}
