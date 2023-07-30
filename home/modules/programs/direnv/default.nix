{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.hopplaos.programs.direnv;
in {
  options.hopplaos.programs.direnv.enable = mkEnableOption "Direnv";

  config = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
