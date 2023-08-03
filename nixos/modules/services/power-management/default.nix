{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.hopplaos.services.power-management;
in {
  options.hopplaos.services.power-management = {
    laptopMode = lib.mkEnableOption "Power management - laptop mode";
  };

  config = {
    boot.kernelModules = [
      "cpufreq_ondemand"
      "cpufreq_powersave"
      "cpufreq_performance"
    ];

    services = {
      upower = lib.mkIf cfg.laptopMode {
        enable = true;
        criticalPowerAction = "HybridSleep";
        usePercentageForPolicy = true;
      };
      cpupower-gui.enable = true;
      thermald.enable = true;

      tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
          PLATFORM_PROFILE_ON_AC = "performance";
          DISK_DEVICES = "nvme0n1 sda";
          DISK_APM_LEVEL_ON_AC = "254 254";
          MAX_LOST_WORK_SECS_ON_AC = 15;
        } // lib.mkIf cfg.laptopMode {
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
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
