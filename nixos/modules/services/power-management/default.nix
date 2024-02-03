{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.hopplaos.services.power-management;
in {
  options.hopplaos.services.power-management = {
    hasBattery = lib.mkEnableOption "Power management - laptop mode";
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
        settings =
          {
            CPU_SCALING_GOVERNOR_ON_AC = "performance";
            CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
            CPU_BOOST_ON_AC = 1;
            PLATFORM_PROFILE_ON_AC = "performance";
            DISK_DEVICES = "nvme0n1 sda";
            START_CHARGE_THRESH_BAT0 = 75;
            STOP_CHARGE_THRESH_BAT0 = 80;
          }
          // lib.mkIf cfg.hasBattery {
            CPU_SCALING_GOVERNOR_ON_BAT =
              if cfg.pstate
              then "active"
              else "ondemand";
            CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
            CPU_BOOST_ON_BAT = 0;
            PLATFORM_PROFILE_ON_BAT = "balanced";
          };
      };
    };

    environment.systemPackages = [
      pkgs.powertop
      config.boot.kernelPackages.cpupower
    ];
  };
}
