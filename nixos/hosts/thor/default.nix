{
  imports = [ ./disko.nix ];

  hopplaos = {
    profiles = { desktop = true; };
    users.vincentcui.enable = true;
    boot.grub.osProber = true;
    hardware = {
      enable = true;
      bluetooth = true;
      cpu.manufacturer = "amd";
      gpu.manufacturer = "amd";
    };
  };

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];

  networking.interfaces.enp4s0.useDHCP = true;
}
