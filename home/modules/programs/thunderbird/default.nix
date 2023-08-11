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

  cfg = config.hopplaos.programs.thunderbird;
in {
  options.hopplaos.programs.thunderbird = {
    enable = mkEnableOption "Thunderbird";
  };

  config = mkIf cfg.enable {
    home.packages = [pkgs.thunderbird];
  };
}
