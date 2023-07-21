{
  hopplaos = {
    profiles = { desktop = true; };
    users.vincentcui.enable = true;
    wibu = {
      enable = true;
      share.enable = true;
    };
    boot.grub.osProber = true;
    hardware = {
      enable = true;
      cpu.manufacturer = "intel";
      gpu.manufacturer = "intel";
    };
  };

  boot.initrd.availableKernelModules =
    [ "vmd" "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];

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

  swapDevices = [{ label = "swap"; }];
}
