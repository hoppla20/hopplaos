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
    services.cache.serve = true;
  };

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "sd_mod"];
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking = {
    useDHCP = false;
    bridges = {
      "vmbr0" = {
        interfaces = ["enp4s0"];
      };
    };
    interfaces = {
      enp4s0 = {
        useDHCP = false;
        proxyARP = true;
      };
      vmbr0.useDHCP = true;
    };
  };

  fileSystems."/var/lib/libvirt/images" = {
    device = "/storage/libvirt/images";
    options = ["bind"];
  };
}
