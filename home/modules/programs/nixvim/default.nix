{
  pkgs,
  config,
  lib,
  self',
  ...
}: let
  cfg = config.hopplaos.programs.nixvim;
  package =
    if config.hopplaos.desktop.darkTheme
    then self'.packages.nixvim-dark
    else self'.packages.nixvim-light;
in {
  options.hopplaos.programs.nixvim.enable = lib.mkEnableOption "NixVim";

  config = lib.mkIf cfg.enable {
    home.packages = [package];
  };
}
