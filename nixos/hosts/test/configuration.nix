{
  pkgs,
  config,
  lib,
  inputs,
  inputs',
  ...
}: {
  boot = {
    kernelParams = ["console=ttyS0"];
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };

    initrd = {
      kernelModules = [];
      availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" "e1000e"];
    };
  };
}
