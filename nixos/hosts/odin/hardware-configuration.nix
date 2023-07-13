{pkgs, ...}: {
  boot.initrd.availableKernelModules = ["nvme" "ehci_pci" "xhci_pci" "rtsx_pci_sdmmc"];
}
