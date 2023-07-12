{
  boot = {
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];

    kernelParams = ["amd_pstate=passive" "amd_pstate.shared_mem=1"];
    blacklistedKernelModules = ["acpi_cpufreq"];

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
