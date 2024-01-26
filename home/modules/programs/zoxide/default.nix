{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.hopplaos.programs.zoxide;
in {
  options.hopplaos.programs.zoxide.enable = mkEnableOption "Programs - zoxide";

  config = mkIf cfg.enable {
    programs.zoxide.enable = true;
  };
}
