{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [./disko.nix];

  hopplaos = {
    profiles = {desktop = true;};
    users.vincentcui = {
      enable = true;
      hmUser = "vincentcui-wibu@${config.networking.hostName}";
    };
    wibu = {
      enable = true;
      share.enable = true;
    };
    boot.grub.osProber = false;
    hardware = {
      enable = true;
      bluetooth = true;
      cpu.manufacturer = "intel";
      gpu.manufacturer = "intel";
    };
  };

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
    kernelParams = [
      # fix flicker
      # source https://wiki.archlinux.org/index.php/Intel_graphics#Screen_flickering
      "i915.enable_psr=0"
    ];
  };

  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;
}
