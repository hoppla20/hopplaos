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

  cfg = config.hopplaos.programs.lf;
in {
  options.hopplaos.programs.lf = {
    enable = mkEnableOption "Lf file manager";
  };

  config = mkIf cfg.enable {
    programs.lf = {
      enable = true;
      keybindings = {
        D = "trash";
        i = "$more $f";
      };
    };
  };
}
