{
  pkgs,
  config,
  lib,
  ...
}: let
in {
  programs.nix-index-database.comma.enable = true;
  home.stateVersion = lib.mkDefault "23.05";
}
