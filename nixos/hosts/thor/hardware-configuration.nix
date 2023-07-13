{
  #boot.initrd.availableKernelModules = [];

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
