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
    enable = mkEnableOption "Email";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.thunderbird];
    programs.evolution = {
      enable = true;
      plugins = [pkgs.evolution-ews];
    };
  };
}
