{
  pkgs,
  config,
  lib,
  self',
  ...
}: let
  cfg = config.hopplaos.programs.emacs;
  package = self'.packages.emacsWithPackages;
in {
  options.hopplaos.programs.emacs.enable = lib.mkEnableOption "Emacs";

  config = lib.mkIf cfg.enable {
    programs.emacs = {
      enable = true;
      # extraConfig
      # extraPackages
      # overrides
      inherit package;
    };
    services.emacs = {
      enable = true;
      client.enable = true;
      socketActivation.enable = false;
      inherit package;
    };
  };
}
