{
  pkgs-unstable,
  lib,
  config,
  ...
}: let
  cfg = config.hopplaos.programs.notetaking;
in {
  options.hopplaos.programs.notetaking.enable = lib.mkEnableOption "Notetaking";

  config = lib.mkIf cfg.enable {
    home.packages = builtins.attrValues {
      inherit
        (pkgs-unstable)
        logseq
        ;
    };
  };
}
