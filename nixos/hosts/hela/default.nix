{
  pkgs,
  config,
  lib,
  ...
}: {
  hopplaos = {
    profiles = {desktop = true;};
    users.vincentcui = {
      enable = true;
      hmUser = "vincentcui-wibu@${config.networking.hostName}";
    };
    wibu = {
      enable = true;
      share.enable = true;
    };
    boot.grub.osProber = true;
    hardware = {
      enable = true;
      bluetooth = false;
      cpu.manufacturer = "intel";
      gpu.manufacturer = "intel";
    };
  };

  boot = {
    initrd.availableKernelModules = ["vmd" "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];

    # TODO Wait for https://github.com/NixOS/nixpkgs/pull/224990
    kernelPackages = lib.mkForce pkgs.linuxPackages_6_5;
  };

  networking.interfaces.enp0s31f6.useDHCP = true;

  fileSystems = {
    "/" = {
      label = "nixos";
      fsType = "ext4";
    };
    "/boot" = {
      label = "ESP";
      fsType = "vfat";
    };
  };

  swapDevices = [{label = "swap";}];
}
