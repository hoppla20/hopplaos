{
  pkgs,
  config,
  lib,
  inputs,
  inputs',
  ...
}: {
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  hopplaos = {
    users.vincentcui.enable = true;
  };
}
