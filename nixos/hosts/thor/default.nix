{
  hopplaos = {
    hardware = {
      cpu.manufacturer = "amd";
      gpu.manufacturer = "amd";
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
    boot = {
      enable = true;
      kernelModules.kvm.enable = true;
      grub = {
        enable = true;
        osProber = true;
      };
    };
  };

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "sd_mod"];

  networking.interfaces.enp4s0.useDHCP = true;

  fileSystems = {
    "/" = {
      label = "nixos";
      fsType = "ext4";
    };
    "/boot" = {
      label = "BOOT";
      fsType = "vfat";
    };
    "/storage" = {
      label = "storage";
      fsType = "ext4";
    };
  };

  swapDevices = [{label = "swap";}];
}
