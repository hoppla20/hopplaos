{
  pkgs,
  pkgs-unstable,
  config,
  lib,
  inputs,
  self,
  inputs',
  self',
  ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs self inputs' self' pkgs-unstable;};
  };
}
