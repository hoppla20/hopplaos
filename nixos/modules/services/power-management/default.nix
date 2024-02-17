{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.hopplaos.services.power-management;
  hardwareCfg = config.hopplaos.hardware;
in {
  options.hopplaos.services.power-management = {
    pstate =
      lib.mkEnableOption "Intel/AMD pstate"
      // {
        default =
          (lib.elem
            "${config.hopplaos.hardware.cpu.manufacturer}-pstate"
            config.boot.kernelModules)
          || (builtins.any
            (p: builtins.isList (builtins.match "amd_pstate=[[:alpha:]]+" p))
            config.boot.kernelParams);
      };
  };

  config = {
    boot.kernelModules = [
      "cpufreq_ondemand"
      "cpufreq_powersave"
      "cpufreq_performance"
    ];

    services = {
      upower = {
        enable = true;
        criticalPowerAction = "HybridSleep";
        usePercentageForPolicy = true;
      };
      thermald.enable = true;

      tlp = {
        enable = true;
        settings = lib.mkMerge [
          {
            PLATFORM_PROFILE_ON_AC = "performance";
            PLATFORM_PROFILE_ON_BAT = "balanced";

            CPU_SCALING_GOVERNOR_ON_AC = "performance";
            CPU_SCALING_GOVERNOR_ON_BAT = "ondemand";

            CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
            CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

            CPU_BOOST_ON_AC = 1;
            CPU_BOOST_ON_BAT = 0;

            # Intel HWP dynamyc boost
            CPU_HWP_DYN_BOOST_ON_AC = 1;
            CPU_HWP_DYN_BOOST_ON_BAT = 0;

            DISK_DEVICES = "nvme0n1 sda";

            START_CHARGE_THRESH_BAT0 = 75;
            STOP_CHARGE_THRESH_BAT0 = 80;
          }
          (lib.mkIf cfg.pstate {
            CPU_DRIVER_OPMODE_ON_AC = "active";
            CPU_DRIVER_OPMODE_ON_BAT = "active";

            CPU_SCALING_GOVERNOR_ON_BAT = "powersafe";
          })
          (lib.mkIf (hardwareCfg.gpu.manufacturer == "amd") {
            RADEON_DPM_STATE_ON_AC = "performance";
            RADEON_DPM_STATE_ON_BAT = "balanced";
          })
        ];
      };
    };

    environment.systemPackages = [
      pkgs.powertop
      config.boot.kernelPackages.cpupower
    ];
  };
}
