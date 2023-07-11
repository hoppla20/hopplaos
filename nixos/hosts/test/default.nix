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
    desktop = {
      enable = true;
      thunar.enable = true;
      hyprland.enable = true;
      sway.enable = true;
    };
  };
}
