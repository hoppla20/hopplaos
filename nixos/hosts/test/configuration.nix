{
  boot = {
    kernelParams = ["console=ttyS0"];
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];

    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };

      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };
  };
}
