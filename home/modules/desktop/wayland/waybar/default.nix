{
  pkgs,
  config,
  lib,
  self',
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkIf
    mkDefault
    ;

  desktopCfg = config.hopplaos.desktop;
  cfg = desktopCfg.wayland.waybar;
in {
  options = {
    hopplaos.desktop.wayland.waybar = {
      enable = mkEnableOption "Waybar";
    };
  };

  config = {
    home.packages = builtins.attrValues {
      inherit
        (pkgs)
        waybar
        networkmanagerapplet
        ;

      inherit
        (self'.packages)
        pulseaudio-control
        ;
    };

    xdg.configFile = {
      "waybar/config".source = pkgs.substituteAll {
        name = "config";
        src = ./config;
        light = "${pkgs.light}/bin/light";
      };
      "waybar/style.css".source = ./style.css;
    };

    systemd.user.services.waybar = {
      Unit = {
        Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
        Documentation = "https://github.com/Alexays/Waybar/wiki";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };
      Service = {
        ExecStart = "${pkgs.waybar}/bin/waybar";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        KillMode = "mixed";
      };
      Install = {WantedBy = mkDefault ["sway-session.target"];};
    };

    services = {
      network-manager-applet.enable = true;
      blueman-applet.enable = true;
    };

    systemd.user.services.network-manager-applet.Service = {
      ExecStart = lib.mkForce "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
    };
  };
}
