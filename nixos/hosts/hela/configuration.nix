{
  boot = {
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];

    kernelParams = [];
    blacklistedKernelModules = [];

    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
      };
    };
  };
}
