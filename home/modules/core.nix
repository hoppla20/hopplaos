{
  pkgs,
  config,
  lib,
  ...
}: let
in {
  home.stateVersion = lib.mkDefault "23.05";
}
