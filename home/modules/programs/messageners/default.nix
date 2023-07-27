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

  cfg = config.hopplaos.programs.messangers;
in {
  options.hopplaos.programs.messangers = {
    enable = mkEnableOption "Messangers";
  };

  config = mkIf cfg.enable {
    home.packages = builtins.attrValues {
      inherit
        (pkgs)
        signal-desktop
        whatsapp-for-linux
        element-desktop
        ;
    };
  };
}
