{pkgs, ...}: {
  boot.initrd.availableKernelModules = ["nvme" "ehci_pci" "xhci_pci" "rtsx_pci_sdmmc"];

  disko.devices = import ./disko.nix {disks = ["/dev/nvme0n1"];};
}
