{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption mkEnableOption mkIf mkMerge;

  cfg = config.hopplaos.profiles.desktop;
in {
  options.hopplaos.profiles.desktop = mkEnableOption "Desktop Profile";

  config = mkIf cfg {
    hopplaos = {
      boot = {
        enable = true;
        kernelModules.kvm.enable = true;
        grub.enable = true;
        plymouth.enable = true;
      };

      desktop = {
        enable = true;
        thunar.enable = true;
        wayland.hyprland.enable = true;
      };

      programs = {
        email.enable = true;
      };

      services = {
        gnome-keyring.enable = true;
        openssh.enable = true;
        kmonad.enable = false;
      };

      virtualisation = {
        qemu.enable = true;
        libvirt.enable = true;
        containers.enable = true;
      };

      hardware = {
        logitech.enable = true;
        securitykeys.enable = true;
        zsa.enable = true;
      };

      cross-arch.enable = true;

      server-management.enable = true;
      android.enable = true;
    };
  };
}
