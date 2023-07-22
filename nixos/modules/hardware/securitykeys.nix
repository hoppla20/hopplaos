{pkgs, config, lib, ...}: let
  inherit
    (lib)
    types
    mkEnableOption
    mkIf
    ;

  hardwareCfg = config.hopplaos.hardware;
  cfg = hardwareCfg.securitykeys;
in {
  options.hopplaos.hardware.securitykeys = {
    enable = mkEnableOption "Security Keys";
  };

  config = mkIf (hardwareCfg.enable && cfg.enable) {
    services = {
      udev.packages = with pkgs; [
        yubikey-personalization
      ];

      pcscd.enable = true;
    };

    hardware.nitrokey.enable = true;

    environment.systemPackages = with pkgs; [
      yubikey-manager-qt
      yubioath-flutter
      pynitrokey
    ];
  };
}
