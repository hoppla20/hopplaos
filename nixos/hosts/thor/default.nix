{
  imports = [./disko.nix];

  hopplaos = {
    profiles = {desktop = true;};
    users.vincentcui.enable = true;
    boot.grub.osProber = true;
    hardware = {
      enable = true;
      bluetooth = true;
      cpu.manufacturer = "amd";
      gpu.manufacturer = "amd";
    };
    networking.wakeOnLan = {
      enable = true;
      interface = "enp4s0";
    };
  };

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "sd_mod"];

  networking.interfaces.enp4s0.useDHCP = true;

  fileSystems."/var/lib/libvirt/images" = {
    device = "/storage/libvirt/images";
    options = ["bind"];
  };
}
