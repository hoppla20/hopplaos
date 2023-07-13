{
  boot = {
    kernelParams = ["amd_pstate=passive" "amd_pstate.shared_mem=1"];
    blacklistedKernelModules = ["acpi_cpufreq"];
  };
}
