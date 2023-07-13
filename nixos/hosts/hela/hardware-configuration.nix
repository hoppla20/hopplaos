{
  boot.initrd = {
    kernelModules = [];
    availableKernelModules = ["vmd" "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
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
