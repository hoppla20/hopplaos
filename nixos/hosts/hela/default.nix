{
  hopplaos = {
    hardware = {
      enable = true;
      cpu.manufacturer = "intel";
      gpu.manufacturer = "intel";
    };
    users.vincentcui.enable = true;
    desktop = {
      enable = true;
      thunar.enable = true;
      wayland = {
        hyprland.enable = true;
        sway.enable = true;
      };
    };
    wibu = {
      enable = true;
      share.enable = true;
    };
    boot = {
      enable = true;
      kernelModules.kvm.enable = true;
      grub = {
        enable = true;
        osProber = true;
      };
    };
  };

  boot.initrd.availableKernelModules = ["vmd" "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];

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
