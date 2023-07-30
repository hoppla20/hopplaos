{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  inherit
    (lib)
    types
    mkOption
    mkEnableOption
    mkIf
    mkForce
    ;
  inherit (desktopCfg) audio brightnessControlCommands;

  desktopCfg = config.hopplaos.desktop;
  cfg = desktopCfg.wayland.waybar;
in {
  options = {
    hopplaos.desktop.wayland.waybar = {
      enable =
        mkEnableOption "Waybar"
        // {
          default = desktopCfg.wayland.enable;
        };

      launchCommand = mkOption {
        type = types.package;
        readOnly = true;
        default = pkgs.writeShellScript "launch_waybar" ''
          ${pkgs.killall}/bin/killall -q -r waybar || true
          while ${pkgs.procps}/bin/pgrep -u $UID -x waybar >/dev/null; do sleep 1; done
          ${config.programs.waybar.package}/bin/waybar
        '';
      };
    };
  };

  config = mkIf (desktopCfg.enable && cfg.enable) {
    programs.waybar = {
      enable = true;
      package = pkgs.waybar-experimental;
      systemd.enable = false;

      style =
        pkgs.writeText "style.css"
        (builtins.readFile (config.scheme inputs.base16-waybar)
          + ''
            window#waybar {
              font-family: ${config.gtk.font.name};
            }
          ''
          + builtins.readFile ./style.css);

      settings = {
        main = {
          layer = "top";
          position = "top";
          spacing = 5;

          margin-top = 5;
          margin-bottom = 5;
          margin-left = 5;
          margin-right = 5;

          modules-left = [
            "cpu"
            "memory"
            "idle_inhibitor"
            "sway/mode"
            "tray"
            "hyprland/submap"
          ];
          modules-center = ["sway/workspaces" "wlr/workspaces"];
          modules-right = ["backlight" "network" "wireplumber" "clock" "battery"];

          "sway/workspaces" = {disable-scroll = true;};
          "wlr/workspaces" = {
            format = "{name}";
            on-click = "activate";
            sort-by-number = true;
          };
          "wireplumber" = {
            tooltip = false;
            scroll-step = 5;
            max-volume = 150;
            on-click = audio.controlCommands.mute;
            on-click-right = audio.managerCommand;

            format = "{icon}  {volume}%";
            format-muted = "󰝟  muted";
            format-icons = ["" "" ""];
          };
          "network" = {
            tooltip = false;
            format = "{ifname} {ipaddr}/{cidr}";
            format-wifi = "   {essid:5}";
            format-ethernet = "󰈀  {ipaddr}/{cidr}";
            format-disconnected = "";
            max-length = 50;
          };
          "backlight" = {
            tooltip = false;
            format = " {}%";
            interval = 1;
            on-scroll-up = brightnessControlCommands.raise;
            on-scroll-down = brightnessControlCommands.lower;
          };
          "battery" = {
            states = {
              good = 75;
              warning = 20;
              critical = 10;
            };
            full-at = 79;

            format = "{icon}  {capacity}%";
            format-charging = "  {capacity}%";
            format-plugged = "  {capacity}%";
            format-icons = ["" "" "" "" ""];
          };
          "tray" = {
            tooltip = false;
            icon-size = 18;
            spacing = 10;
          };
          "clock" = {
            tooltip = false;
            interval = 15;
            format = "{:  %H:%M 󰃭  %d.%m.%Y}";
          };
          "cpu" = {
            interval = 10;
            format = "  {}%";
            max-length = 10;
          };
          "memory" = {
            interval = 10;
            format = "  {}%";
            max-length = 10;
          };
          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              deactivated = "󱠛";
              activated = "󱤱";
            };
          };
        };
      };
    };

    services = {
      network-manager-applet.enable = true;
      blueman-applet.enable = true;
    };

    systemd.user.services.network-manager-applet.Service = {
      ExecStart =
        lib.mkForce "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
    };

    xdg.configFile."waybar/config".onChange = mkForce "";
    xdg.configFile."waybar/style.css".onChange = mkForce "";
  };
}
