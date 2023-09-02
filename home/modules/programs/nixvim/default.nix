{
  pkgs,
  config,
  lib,
  self',
  ...
}: {
  options.hopplaos.programs.nixvim.enable = lib.mkEnableOption "NixVim";

  config = {
    home.packages = [
      (
        if config.hopplaos.desktop.darkTheme
        then self'.packages.nixvim-dark
        else self'.packages.nixvim-light
      )
    ];
  };
}
