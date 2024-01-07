{
  inputs,
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

  cfg = config.hopplaos.services.kmonad;
in {
  imports = [inputs.kmonad.nixosModules.default];

  options.hopplaos.services.kmonad = {
    enable = mkEnableOption "kmonad";
  };

  config = mkIf cfg.enable {
    services.kmonad = {
      enable = true;
    };
  };
}
