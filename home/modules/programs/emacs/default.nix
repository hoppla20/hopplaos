{
  pkgs,
  config,
  lib,
  self',
  ...
}: let
  cfg = config.hopplaos.programs.emacs;
  inherit (config.hopplaos.desktop) darkTheme;
  catppuccinTheme =
    if darkTheme
    then "macchiato"
    else "latte";
in {
  options.hopplaos.programs.emacs.enable = lib.mkEnableOption "Emacs";

  config = lib.mkIf cfg.enable {
    programs.emacs = {
      enable = true;
      package = self'.packages.emacsWithPackages;
      extraPackages = epkgs: [epkgs.catppuccin-theme];
      extraConfig = ''
        (setq hoppla/catppuccin-flavor '${catppuccinTheme})
      '';
      # overrides
    };
    services.emacs = {
      enable = true;
      client.enable = true;
      socketActivation.enable = false;
    };
  };
}
