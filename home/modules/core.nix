{
  pkgs,
  config,
  lib,
  ...
}: {
  programs.nix-index-database.comma.enable = true;
  home.stateVersion = lib.mkDefault "23.11";
}
