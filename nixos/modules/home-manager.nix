{
  pkgs,
  config,
  lib,
  inputs,
  inputs',
  self',
  ...
}: {
  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs inputs' self';
    };
  };
}
