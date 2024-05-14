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
      backup.enable = true;
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

    # TODO Wait for https://github.com/NixOS/nixpkgs/pull/224990, https://github.com/NixOS/nixpkgs/issues/34638, https://github.com/NixOS/nixpkgs/issues/34638
    kernelPackages = lib.mkForce pkgs.linuxPackages_6_1;
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
    "/backup" = {
      label = "Backup";
      fsType = "ntfs";
      options = ["defaults" "nofail"];
    };
    "/storage" = {
      label = "data";
      fsType = "ext4";
      options = ["defaults" "nofail"];
    };
  };

  swapDevices = [{label = "swap";}];
}
