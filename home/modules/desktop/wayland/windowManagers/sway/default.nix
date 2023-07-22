{ pkgs, config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (desktopCfg)
    polkitAgent systemCommands appLauncherCommand terminalCommand browserCommand
    editorCommand fileManagerCommand brightnessControlCommands audio;

  hardwareCfg = config.hopplaos.hardware;
  desktopCfg = config.hopplaos.desktop;
  cfg = desktopCfg.wayland.sway;

  system-control-mode =
    "(e)xit_(l)ock_(s)uspend_(h)ibernate_(S)hutdown_(r)eboot";
in
{
  options = {
    hopplaos.desktop.wayland.sway = { enable = mkEnableOption "Sway"; };
  };

  config = mkIf (desktopCfg.enable && cfg.enable) {
    wayland.windowManager.sway = {
      enable = true;

      # use system package
      package = null;
      systemdIntegration = true;

      config = {
        modifier = "Mod4";

        fonts = {
          names = [ config.gtk.font.name ];
          style = "Regular";
          size = 12.0;
        };

        window = {
          titlebar = false;
          border = 2;
        };

        focus = {
          newWindow = "smart";
          followMouse = false;
          forceWrapping = false;
          mouseWarping = false;
        };

        workspaceLayout = "default";

        colors = {
          focused = {
            border = "#6272A4";
            background = "#6272A4";
            text = "#F8F8F2";
            indicator = "#6272A4";
            childBorder = "#6272A4";
          };
          focusedInactive = {
            border = "#44475A";
            background = "#44475A";
            text = "#F8F8F2";
            indicator = "#44475A";
            childBorder = "#44475A";
          };
          unfocused = {
            border = "#282A36";
            background = "#282A36";
            text = "#BFBFBF";
            indicator = "#282A36";
            childBorder = "#282A36";
          };
          urgent = {
            border = "#44475A";
            background = "#FF5555";
            text = "#F8F8F2";
            indicator = "#FF5555";
            childBorder = "#FF5555";
          };
          placeholder = {
            border = "#282A36";
            background = "#282A36";
            text = "#F8F8F2";
            indicator = "#282A36";
            childBorder = "#282A36";
          };
          background = "#F8F8F2";
        };

        gaps = {
          inner = 8;
          outer = 2;
        };

        modes = {
          resize = {
            Escape = ''mode "default"'';
            Return = ''mode "default"'';
            h = "resize shrink width 10 px or 10 ppt";
            j = "resize shrink height 10px or 10 ppt";
            k = "resize grow height 10 px or 10 ppt";
            l = "resize grow width 10 px or 10 ppt";
          };
          "${system-control-mode}" = {
            Escape = ''mode "default"'';
            e = ''exit, mode "default"'';
            l = ''exec ${systemCommands.lock}, mode "default"'';
            s = ''exec ${systemCommands.suspend}, mode "default"'';
            h = ''exec ${systemCommands.hibernate}, mode "default"'';
            r = ''exec ${systemCommands.reboot}, mode "default"'';
            "Shift+s" = ''exec ${systemCommands.poweroff}, mode "default"'';
          };
        };

        keybindings = {
          "Mod4+F1" = "exec ${editorCommand}";
          "Mod4+F10" = "exec ${audio.playerCommand}";
          "Mod4+F2" = "exec ${browserCommand}";
          "Mod4+F3" = "exec ${fileManagerCommand}";
          "Mod4+Return" = "exec ${terminalCommand}";
          "Mod4+Shift+m" = "exec ${audio.managerCommand}";
          "Mod4+w" = "exec ${appLauncherCommand}";

          "Mod1+Tab" = "workspace next";
          "Mod1+Shift+Tab" = "workspace prev";

          "Mod4+1" = "workspace 1";
          "Mod4+2" = "workspace 2";
          "Mod4+3" = "workspace 3";
          "Mod4+4" = "workspace 4";
          "Mod4+5" = "workspace 5";
          "Mod4+6" = "workspace 6";
          "Mod4+7" = "workspace 7";
          "Mod4+8" = "workspace 8";
          "Mod4+9" = "workspace 9";

          "Mod4+0" = ''mode "${system-control-mode}"'';

          "Mod4+Shift+1" = "move container to workspace 1; workspace 1";
          "Mod4+Shift+2" = "move container to workspace 2; workspace 2";
          "Mod4+Shift+3" = "move container to workspace 3; workspace 3";
          "Mod4+Shift+4" = "move container to workspace 4; workspace 4";
          "Mod4+Shift+5" = "move container to workspace 5; workspace 5";
          "Mod4+Shift+6" = "move container to workspace 6; workspace 6";
          "Mod4+Shift+7" = "move container to workspace 7; workspace 7";
          "Mod4+Shift+8" = "move container to workspace 8; workspace 8";
          "Mod4+Shift+9" = "move container to workspace 9; workspace 9";

          "Mod4+control+1" = "move container to workspace 1";
          "Mod4+control+2" = "move container to workspace 2";
          "Mod4+control+3" = "move container to workspace 3";
          "Mod4+control+4" = "move container to workspace 4";
          "Mod4+control+5" = "move container to workspace 5";
          "Mod4+control+6" = "move container to workspace 6";
          "Mod4+control+7" = "move container to workspace 7";
          "Mod4+control+8" = "move container to workspace 8";
          "Mod4+control+9" = "move container to workspace 9";

          "Mod4+control+h" = "move workspace to output left";
          "Mod4+control+j" = "move workspace to output down";
          "Mod4+control+k" = "move workspace to output up";
          "Mod4+control+l" = "move workspace to output right";

          "Mod4+h" = "focus left";
          "Mod4+j" = "focus down";
          "Mod4+k" = "focus up";
          "Mod4+l" = "focus right";

          "Mod4+Shift+h" = "move left";
          "Mod4+Shift+j" = "move down";
          "Mod4+Shift+k" = "move up";
          "Mod4+Shift+l" = "move right";

          "Mod4+Shift+minus" = "move scratchpad";
          "Mod4+minus" = "scratchpad show";

          "Mod4+Shift+q" = "kill";
          "Mod4+Shift+space" = "floating toggle";
          "Mod4+Tab" = "workspace back_and_forth";
          "Mod4+a" = "focus parent";
          "Mod4+f" = "fullscreen toggle";
          "Mod4+q" = "split toggle";
          "Mod4+r" = ''mode "resize"'';
          "Mod4+space" = "focus mode_toggle";

          "Mod4+m" = "mark %s' -l 1 -P 'Mark: ";
          "Mod4+g" = ''[con_mark="%s"] focus' -l 1 -P 'Goto: '';

          "Mod4+s" = "layout stacking";
          "Mod4+t" = "layout tabbed";
          "Mod4+semicolon" = "layout toggle split";

          "Mod4+Shift+r" = "reload";

          "XF86AudioRaiseVolume" = "exec ${audio.controlCommands.raise}";
          "XF86AudioLowerVolume" = "exec ${audio.controlCommands.lower}";
          "XF86AudioMute" = "exec ${audio.controlCommands.mute}";

          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioPrev" = "exec playerctl previous";
          "XF86AudioStop" = "exec playerctl stop";

          "XF86MonBrightnessDown" = "exec ${brightnessControlCommands.lower}";
          "XF86MonBrightnessUp" = "exec ${brightnessControlCommands.raise}";

          "Control+Shift+period" = "exec dunstctl context";
          "Control+Shift+comma" = "exec dunstctl close";
          "Control+Shift+minus" = "exec dunstctl history-pop";

          "Print" = "exec screenshot";
          "Control+Print" = "exec screenshot-select";
          "Mod4+Print" = "exec screenshot-window";
          "Shift+Print" = "exec screenshot-clip";
          "Control+Shift+Print" = "exec screenshot-select-clip";
          "Mod4+Shift+Print" = "exec screenshot-window-clip";
        };

        left = "h";
        down = "j";
        up = "k";
        right = "l";

        input = {
          "type:keyboard" = {
            xkb_layout = "us";
            xkb_variant = "altgr-intl";
            xkb_options = "caps:escape";
          };
          "type:touchpad" = {
            left_handed = "false";
            tap = "enabled";
            natural_scroll = "enabled";
            dwt = "enabled";
            accel_profile =
              "adaptive"; # disable mouse acceleration (enabled by default; to set it manually, use "adaptive" instead of "flat")
            pointer_accel = "0.3"; # set mouse sensitivity (between -1 and 1)
          };
        };

        output = builtins.mapAttrs
          (name: value: {
            mode = lib.mkIf (!(builtins.isNull value.resolution))
              "${value.resolution}${
              if !(builtins.isNull value.refreshRate) then
                "@${toString value.refreshRate}Hz"
              else
                ""
            }";
            background = lib.mkIf (!(builtins.isNull value.background))
              "${value.background.file} ${value.background.mode}";
            transform = lib.mkIf (!(builtins.isNull value.transform))
              (toString value.transform);
            position = lib.mkIf (!(builtins.isNull value.position))
              "${toString value.position.x} ${toString value.position.y}";
          })
          (builtins.listToAttrs hardwareCfg.monitors);

        bars = [ ];

        startup =
          [{ command = "wl-configure-gtk"; } { command = polkitAgent; }];

        workspaceOutputAssign =
          mkIf ((builtins.length hardwareCfg.monitors) > 0) (
            let
              monitor0 = (builtins.elemAt hardwareCfg.monitors 0).name;
              monitor1 =
                if ((builtins.length hardwareCfg.monitors) > 1) then
                  (builtins.elemAt hardwareCfg.monitors 1).name
                else
                  (builtins.elemAt hardwareCfg.monitors 0).name;
            in
            [
              {
                workspace = "1";
                output = monitor0;
              }
              {
                workspace = "2";
                output = monitor0;
              }
              {
                workspace = "3";
                output = monitor0;
              }
              {
                workspace = "4";
                output = monitor0;
              }
              {
                workspace = "5";
                output = monitor0;
              }
              {
                workspace = "6";
                output = monitor1;
              }
              {
                workspace = "7";
                output = monitor1;
              }
              {
                workspace = "8";
                output = monitor1;
              }
              {
                workspace = "9";
                output = monitor1;
              }
            ]
          );
      };

      extraConfig = ''
        default_orientation auto
        popup_during_fullscreen smart
      '';
    };

    home.packages = [
      (pkgs.writeShellScriptBin "sway-focused-window-geometry"
        "swaymsg -t get_tree | jq -j '.. | select(.type?) | select(.focused).rect | \"\\(.x),\\(.y) \\(.width)x\\(.height)\"'")
      (pkgs.writeShellScriptBin "screenshot-window" ''
        mkdir -p ~/Pictures/Screenshots && grim -g "$(sway-focused-window-geometry)" ~/Pictures/Screenshots/$(date -u +"%Y-%m-%d_%H-%M-%S_grim.png")'')
    ];
  };
}
