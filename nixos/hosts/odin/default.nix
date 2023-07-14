{
  imports = [
    ./disko.nix
  ];

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
      grub.enable = true;
    };
  };

  boot.initrd.availableKernelModules = ["nvme" "ehci_pci" "xhci_pci" "rtsx_pci_sdmmc"];
}
