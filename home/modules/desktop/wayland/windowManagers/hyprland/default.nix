{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (builtins) listToAttrs;
  inherit
    (lib)
    mkEnableOption
    mkIf
    mapAttrsToList
    concatStringsSep
    optionals
    optionalString
    unique
    ;
  inherit
    (desktopCfg)
    polkitAgent
    systemCommands
    appLauncherCommand
    terminalCommand
    browserCommand
    editorCommand
    fileManagerCommand
    brightnessControlCommands
    audio
    ;

  hardwareCfg = config.hopplaos.hardware;
  desktopCfg = config.hopplaos.desktop;
  cfg = desktopCfg.wayland.hyprland;

  transformList = {
    "90" = 1;
    "180" = 2;
    "270" = 3;
    "flipped" = 4;
    "flipped-90" = 5;
    "flipped-180" = 6;
    "flipped-270" = 7;
  };

  monitors = concatStringsSep "\n" (mapAttrsToList
    (name: monitorCfg:
      concatStringsSep ", " ([
          "monitor = ${name}"
          (monitorCfg.resolution
            + (optionalString (monitorCfg.refreshRate != null)
              "@${toString monitorCfg.refreshRate}"))
          (
            if (monitorCfg.position == null)
            then "auto"
            else "${toString monitorCfg.position.x}x${toString monitorCfg.position.y}"
          )
          (toString monitorCfg.scale)
        ]
        ++ optionals (monitorCfg.transform != null) [
          "transform"
          "${toString transformList.${monitorCfg.transform}}"
        ]))
    (listToAttrs config.hopplaos.hardware.monitors));

  wallpapers = unique (map
    (monitor: monitor.value.background.file)
    config.hopplaos.hardware.monitors);

  cursor = config.home.pointerCursor;

  launchHyprpaper = pkgs.writeShellScript "launch_hyprpaper" ''
    ${pkgs.killall}/bin/killall -q -r hyprpaper || true
    while ${pkgs.procps}/bin/pgrep -u $UID -x hyprpaper >/dev/null; do sleep 1; done
    ${pkgs.hyprpaper}/bin/hyprpaper
  '';

  MEH = "SUPER_ALT_SHIFT";
in {
  options = {
    hopplaos.desktop.wayland.hyprland = {
      enable = mkEnableOption "Wayland - Hyprland";
    };
  };

  config = mkIf (desktopCfg.enable && cfg.enable) {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;

      extraConfig = ''
        # Set cursor
        exec-once = hyprctl setcursor ${cursor.name} ${toString cursor.size}

        # Host specific monitors
        ${monitors}
        # Automatically add new monitors to the RIGHT
        monitor=,preferred,auto,1

        # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
        input {
          kb_layout = us
          kb_variant = altgr-intl
          kb_options = caps:escape

          follow_mouse = 2
          mouse_refocus = false
          float_switch_override_focus = 2
          accel_profile = flat
          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

          touchpad {
              drag_lock = true
              natural_scroll = true
          }
        }

        gestures {
          workspace_swipe = true
          workspace_swipe_fingers = 3
          workspace_swipe_distance = 300
          workspace_swipe_min_speed_to_force = 30
          workspace_swipe_cancel_ratio = 0.5
          workspace_swipe_create_new = false
          workspace_swipe_forever = true
          workspace_swipe_numbered = true
        }

        general {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          gaps_in = 5
          gaps_out = 5
          border_size = 1
          layout = master
          resize_on_border = true
          col.inactive_border = rgba(${config.scheme.base02}ee)
          col.active_border = rgba(${config.scheme.base0E}ee)
        }

        misc {
          vrr = 1
          disable_hyprland_logo = true
          new_window_takes_over_fullscreen = 2
        }

        group {
          col.border_active = rgba(${config.scheme.base0E}ee)
          col.border_inactive = rgba(${config.scheme.base02}ee)

          groupbar {
            gradients = false
            font_size = 10
            text_color = rgb(${config.scheme.base05})
          }
        }

        decoration {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          rounding = 10

          #blur {
          #  enable = true
          #  size = 8
          #  passes = 1
          #  new_optimizations = true
          #}

          drop_shadow = true
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)

          dim_inactive = true
          dim_strength = 0.05
          dim_around = 0.2 # for floating windows with `dimaround`
        }

        animations {
          enabled = true

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          animation = windows, 1, 4, myBezier
          animation = windowsOut, 1, 4, default, popin 80%
          animation = fade, 1, 4, default
          animation = workspaces, 1, 3, default
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
        }

        dwindle {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true # you probably want this
        }

        master {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_is_master = false
          special_scale_factor = 0.8
        }

        gestures {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = false
        }

        binds {
          allow_workspace_cycles = true
          movefocus_cycles_fullscreen = false
        }

        # tile brave PWAs
        windowrulev2 = tile, class:^(Brave-browser)

        windowrulev2 = workspace 8, title:^(3CX)
        windowrulev2 = workspace 8, class:^(Signal|whatsapp-for-linux)$
        windowrulev2 = workspace 9, class:^(Spotify)$
        windowrulev2 = workspace special, class:^(org.keepassxc.KeePassXC)$

        submap = resize
        binde = , LEFT, resizeactive, 20 0
        binde = , RIGHT, resizeactive, -20 0
        binde = , UP, resizeactive, 0 -20
        binde = , DOWN, resizeactive, 0 20
        binde = , H, resizeactive, -20 0
        binde = , L, resizeactive, 20 0
        binde = , K, resizeactive, 0 20
        binde = , J, resizeactive, 0 -20
        bind = , RETURN, submap, reset
        bind = , ESCAPE, submap, reset
        bind = CONTROL, C, submap, reset
        submap = reset

        submap = system
        bind = , L, exec, ${systemCommands.lock}
        bind = , L, submap, reset
        bind = , S, exec, ${systemCommands.suspend}
        bind = , S, submap, reset
        bind = , H, exec, ${systemCommands.hibernate}
        bind = , H, submap, reset
        bind = , E, exit,
        bind = , R, exec, ${systemCommands.reboot}
        bind = SHIFT, S, exec, ${systemCommands.poweroff}
        bind = , ESCAPE, submap, reset
        bind = CONTROL, C, submap, reset
        submap = reset

        bind = SUPER, RETURN, exec, ${terminalCommand}
        bind = ${MEH}, RETURN, exec, ${terminalCommand}
        bind = SUPER, Q, killactive,
        bind = ${MEH}, Q, killactive,
        bind = SUPER, SPACE, togglefloating,
        bind = ${MEH}, SPACE, togglefloating,
        bind = SUPER, F, fullscreen, 0
        bind = ${MEH}, F, fullscreen, 0
        bind = SUPER_SHIFT, F, fakefullscreen,
        bind = SUPER, 0, submap, system
        bind = SUPER, F12, submap, system
        bind = ${MEH}, F12, submap, system
        bind = SUPER, R, submap, resize
        bind = ${MEH}, R, submap, resize
        bind = SUPER, SEMICOLON, layoutmsg, orientationnext
        bind = SUPER_SHIFT, SEMICOLON, layoutmsg, orientationprev
        bind = SUPER, R, exec, hyprctl reload
        bind = ${MEH}, R, exec, hyprctl reload
        bind = SUPER, T, exec, ${config.hopplaos.programs.theme-switcher.package}/bin/theme-switcher
        bind = ${MEH}, T, exec, ${config.hopplaos.programs.theme-switcher.package}/bin/theme-switcher

        bindle = , XF86AudioRaiseVolume, exec, ${audio.controlCommands.raise}
        bindle = , XF86AudioLowerVolume, exec, ${audio.controlCommands.lower}
        bindle = , XF86AudioMute, exec, ${audio.controlCommands.mute}
        bindle = , XF86AudioNext, exec, playerctl next
        bindle = , XF86AudioPlay, exec, playerctl play-pause
        bindle = , XF86AudioPrev, exec, playerctl previous
        bindle = , XF86AudioStop, exec, playerctl stop
        bindle = , XF86MonBrightnessDown, exec, ${brightnessControlCommands.lower}
        bindle = , XF86MonBrightnessUp, exec, ${brightnessControlCommands.raise}

        bind = ${MEH}, PERIOD, exec, dunstctl context
        bind = ${MEH}, COMMA, exec, dunstctl close

        bind = , PRINT, exec, screenshot
        bind = CONTROL, PRINT, exec, screenshot-select
        bind = SUPER, PRINT, exec, screenshot-window
        bind = SHIFT, PRINT, exec, screenshot-clip
        bind = CONTROL_SHIFT, PRINT, exec, screenshot-select-clip
        bind = SUPER_SHIFT, PRINT, exec, screenshot-window-clip

        # Application bindings
        bind = SUPER, F1, exec, ${editorCommand}
        bind = ${MEH}, F1, exec, ${editorCommand}
        bind = SUPER, F2, exec, ${browserCommand}
        bind = ${MEH}, F2, exec, ${browserCommand}
        bind = SUPER, F3, exec, ${fileManagerCommand}
        bind = ${MEH}, F3, exec, ${fileManagerCommand}
        bind = SUPER, F10, exec, ${audio.playerCommand}
        bind = ${MEH}, F10, exec, ${audio.playerCommand}
        bind = SUPER, M, exec, ${audio.managerCommand}
        bind = ${MEH}, M, exec, ${audio.managerCommand}
        bind = SUPER, W, exec, ${appLauncherCommand}
        bind = ${MEH}, W, exec, ${appLauncherCommand}

        # Move focus
        bind = SUPER, LEFT, movefocus, l
        bind = SUPER, RIGHT, movefocus, r
        bind = SUPER, UP, movefocus, u
        bind = SUPER, DOWN, movefocus, d
        bind = SUPER, H, movefocus, l
        bind = SUPER, L, movefocus, r
        bind = SUPER, K, movefocus, u
        bind = SUPER, J, movefocus, d
        bind = ${MEH}, H, movefocus, l
        bind = ${MEH}, L, movefocus, r
        bind = ${MEH}, K, movefocus, u
        bind = ${MEH}, J, movefocus, d

        # Move focused window
        bind = SUPER_SHIFT, H, movewindow, l
        bind = SUPER_SHIFT, L, movewindow, r
        bind = SUPER_SHIFT, K, movewindow, u
        bind = SUPER_SHIFT, J, movewindow, d

        # Move focused window into/outo group
        bind = SUPER, G, togglegroup,
        bind = ${MEH}, G, togglegroup,
        bind = SUPER_SHIFT, LEFT, changegroupactive, b
        bind = SUPER_SHIFT, RIGHT, changegroupactive, f
        # Switch workspaces
        bind = SUPER, TAB, workspace, previous
        bind = SUPER, 1, workspace, 1
        bind = SUPER, 2, workspace, 2
        bind = SUPER, 3, workspace, 3
        bind = SUPER, 4, workspace, 4
        bind = SUPER, 5, workspace, 5
        bind = SUPER, 6, workspace, 6
        bind = SUPER, 7, workspace, 7
        bind = SUPER, 8, workspace, 8
        bind = SUPER, 9, workspace, 9
        bind = ${MEH}, 1, workspace, 1
        bind = ${MEH}, 2, workspace, 2
        bind = ${MEH}, 3, workspace, 3
        bind = ${MEH}, 4, workspace, 4
        bind = ${MEH}, 5, workspace, 5
        bind = ${MEH}, 6, workspace, 6
        bind = ${MEH}, 7, workspace, 7
        bind = ${MEH}, 8, workspace, 8
        bind = ${MEH}, 9, workspace, 9

        # Move active window to a workspace
        bind = SUPER_SHIFT, 1, movetoworkspace, 1
        bind = SUPER_SHIFT, 2, movetoworkspace, 2
        bind = SUPER_SHIFT, 3, movetoworkspace, 3
        bind = SUPER_SHIFT, 4, movetoworkspace, 4
        bind = SUPER_SHIFT, 5, movetoworkspace, 5
        bind = SUPER_SHIFT, 6, movetoworkspace, 6
        bind = SUPER_SHIFT, 7, movetoworkspace, 7
        bind = SUPER_SHIFT, 8, movetoworkspace, 8
        bind = SUPER_SHIFT, 9, movetoworkspace, 9

        # Move active window to a workspace without switching workspace
        bind = CONTROL_${MEH}, 1, movetoworkspacesilent, 1
        bind = CONTROL_${MEH}, 2, movetoworkspacesilent, 2
        bind = CONTROL_${MEH}, 3, movetoworkspacesilent, 3
        bind = CONTROL_${MEH}, 4, movetoworkspacesilent, 4
        bind = CONTROL_${MEH}, 5, movetoworkspacesilent, 5
        bind = CONTROL_${MEH}, 6, movetoworkspacesilent, 6
        bind = CONTROL_${MEH}, 7, movetoworkspacesilent, 7
        bind = CONTROL_${MEH}, 8, movetoworkspacesilent, 8
        bind = CONTROL_${MEH}, 9, movetoworkspacesilent, 9

        # Special workspaces
        bind = CONTROL_${MEH}, F, movetoworkspace, special
        bind = CONTROL_${MEH}, J, togglespecialworkspace,

        # Move/resize windows with mouse buttons
        bindm = SUPER, mouse:272, movewindow
        bindm = SUPER, mouse:273, resizewindow

        # Autostart
        exec = bash ${launchHyprpaper}
        exec = bash ${desktopCfg.wayland.waybar.launchCommand}
        exec = sleep 5; ${pkgs.systemd}/bin/systemctl --user restart swayidle.service
        exec = sleep 5; ${pkgs.systemd}/bin/systemctl --user restart network-manager-applet.service
        ${lib.optionalString config.hopplaos.hardware.bluetooth.enable ''
          exec = sleep 5; ${pkgs.systemd}/bin/systemctl --user restart blueman-applet.service
        ''}
        ${lib.optionalString config.hopplaos.services.nextcloud-client.enable ''
          exec = sleep 5; ${pkgs.systemd}/bin/systemctl --user restart nextcloud-client.service
        ''}
        exec-once = wl-configure-gtk
        exec-once = ${polkitAgent}

        ${lib.optionalString (builtins.length hardwareCfg.monitors > 0) (let
          monitor0 = (builtins.elemAt hardwareCfg.monitors 0).name;
          monitor1 =
            if (builtins.length hardwareCfg.monitors > 1)
            then (builtins.elemAt hardwareCfg.monitors 1).name
            else monitor0;
        in ''
          workspace = 1, monitor:${monitor0}
          workspace = 2, monitor:${monitor0}
          workspace = 3, monitor:${monitor0}
          workspace = 4, monitor:${monitor0}
          workspace = 5, monitor:${monitor0}
          workspace = 6, monitor:${monitor1}
          workspace = 7, monitor:${monitor1}
          workspace = 8, monitor:${monitor1}
          workspace = 9, monitor:${monitor1}
        '')}
      '';
    };

    home.packages = [pkgs.hyprpaper];
    xdg.configFile."hypr/hyprpaper.conf" = {
      text = ''
        ${concatStringsSep "\n" (map (wallpaper: "preload = ${wallpaper}") wallpapers)}
        ${concatStringsSep "\n" (map
          (monitor: "wallpaper = ${monitor.name}, ${monitor.value.background.file}")
          config.hopplaos.hardware.monitors)}
        ${desktopCfg.defaultWallpaper}
      '';
    };
  };
}
