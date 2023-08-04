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
    #boot.kernelModules = lib.mkIf (! cfg.pstate) [
    #  "cpufreq_ondemand"
    #  "cpufreq_powersave"
    #  "cpufreq_performance"
    #];

    services = {
      upower = lib.mkIf cfg.hasBattery {
        enable = true;
        criticalPowerAction = "HybridSleep";
        usePercentageForPolicy = true;
      };
      thermald.enable = true;

      tlp = {
        enable = true;
        settings =
          {
            CPU_SCALING_GOVERNOR_ON_AC =
              if cfg.pstate
              then "active"
              else "schedutil";
            CPU_ENERGY_PERF_POLICY_ON_AC = lib.mkIf cfg.pstate "performance";
            CPU_BOOST_ON_AC = 1;
            PLATFORM_PROFILE_ON_AC = "performance";
            DISK_DEVICES = "nvme0n1 sda";
            DISK_APM_LEVEL_ON_AC = "254 254";
            MAX_LOST_WORK_SECS_ON_AC = 15;
          }
          // lib.mkIf cfg.hasBattery {
            CPU_SCALING_GOVERNOR_ON_BAT =
              if cfg.pstate
              then "active"
              else "schedutil";
            CPU_ENERGY_PERF_POLICY_ON_BAT = lib.mkIf cfg.pstate "balance_power";
            CPU_BOOST_ON_BAT = 0;
            PLATFORM_PROFILE_ON_BAT = "low-power";
            START_CHARGE_THRESH_BAT0 = 75;
            STOP_CHARGE_THRESH_BAT0 = 80;
            DISK_APM_LEVEL_ON_BAT = "128 128";
            MAX_LOST_WORK_SECS_ON_BAT = 15;
          };
      };
    };

    environment.systemPackages = [
      pkgs.powertop
      config.boot.kernelPackages.cpupower
    ];
  };
}
