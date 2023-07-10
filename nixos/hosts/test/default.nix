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
  ];

  hopplaos = {
    users.vincentcui.enable = true;
  };
}
