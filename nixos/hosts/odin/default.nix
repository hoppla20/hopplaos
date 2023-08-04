{
  imports = [./disko.nix];

  hopplaos = {
    profiles = {desktop = true;};
    users.vincentcui.enable = true;
    hardware = {
      enable = true;
      bluetooth = true;
      cpu.manufacturer = "amd";
      gpu.manufacturer = "amd";
    };
    services.power-management.hasBattery = true;
  };

  boot.initrd.availableKernelModules = ["nvme" "ehci_pci" "xhci_pci" "rtsx_pci_sdmmc"];
}
