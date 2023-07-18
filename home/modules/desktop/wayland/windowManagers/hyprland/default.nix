{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit
    (builtins)
    listToAttrs
    ;
  inherit
    (lib)
    mkEnableOption
    mkIf
    mapAttrsToList
    concatStringsSep
    optionals
    optionalString
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
    bRIGHTnessControlCommands
    audio
    ;

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

  monitors =
    concatStringsSep "\n"
    (mapAttrsToList
      (name: monitorCfg:
        concatStringsSep ", " ([
            "monitor = ${name}"
            (monitorCfg.resolution + (optionalString (! (isNull monitorCfg.refreshRate)) "@${toString monitorCfg.refreshRate}"))
            (
              if (isNull monitorCfg.position)
              then "auto"
              else "${toString monitorCfg.position.x}x${toString monitorCfg.position.y}"
            )
            (toString monitorCfg.scale)
          ]
          ++ optionals (! (isNull monitorCfg.transform)) [
            "transform"
            "${toString transformList.${monitorCfg.transform}}"
          ]))
      (listToAttrs config.hopplaos.hardware.monitors));

  cursor = config.home.pointerCursor;
in {
  options = {
    hopplaos.desktop.wayland.hyprland = {
      enable = mkEnableOption "Wayland - Hyprland";
    };
  };

  config = mkIf (desktopCfg.enable && cfg.enable) {
    hopplaos.desktop.wayland.waybar.systemd.targets = ["hyprland-session.target"];

    wayland.windowManager.hyprland = {
      enable = true;
      systemdIntegration = true;
      recommendedEnvironment = false;

      # use system package
      package = null;
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
          accel_profile = flat
          sensitivity = 0 # -1.0 - 1.0, 0 means no modification.

          touchpad {
              natural_scroll = true
          }
        }

        general {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          gaps_in = 5
          gaps_out = 5
          border_size = 1
          col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          col.inactive_border = rgba(595959aa)
          layout = master
        }

        decoration {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          rounding = 10
          blur = true
          blur_size = 3
          blur_passes = 1
          blur_new_optimizations = true

          drop_shadow = true
          shadow_range = 4
          shadow_render_power = 3
          col.shadow = rgba(1a1a1aee)
        }

        animations {
          enabled = true

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = myBezier, 0.05, 0.9, 0.1, 1.05

          animation = windows, 1, 7, myBezier
          animation = windowsOut, 1, 7, default, popin 80%
          animation = border, 1, 10, default
          animation = borderangle, 1, 8, default
          animation = fade, 1, 7, default
          animation = workspaces, 1, 6, default
        }

        dwindle {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true # you probably want this
        }

        master {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_is_master = false
          no_gaps_when_only = true
        }

        gestures {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = false
        }

        submap = resize
        binde = , LEFT, resizeactive, 10 0
        binde = , RIGHT, resizeactive, -10 0
        binde = , UP, resizeactive, 0 -10
        binde = , DOWN, resizeactive, 0 10
        binde = , H, resizeactive, 10 0
        binde = , L, resizeactive, -10 0
        binde = , K, resizeactive, 0 -10
        binde = , J, resizeactive, 0 10
        bind = , ESCAPE, submap, reset
        bind = CONTROL, C, submap, reset
        submap = reset

        submap = system
        bind = , E, exit,
        bind = , L, exec, ${systemCommands.lock}
        bind = , S, exec, ${systemCommands.suspend}
        bind = , H, exec, ${systemCommands.hibernate}
        bind = , R, exec, ${systemCommands.reboot}
        bind = SHIFT, S, exec, ${systemCommands.poweroff}
        bind = , ESCAPE, submap, reset
        bind = CONTROL, C, submap, reset
        submap = reset

        bind = SUPER, RETURN, exec, ${terminalCommand}
        bind = SUPER_SHIFT, Q, killactive,
        bind = SUPER_SHIFT, SPACE, togglefloating,
        bind = SUPER, F, fullscreen,
        bind = SUPER, 0, submap, system
        bind = SUPER, R, submap, resize

        # Application bindings
        bind = SUPER, F1, exec, ${editorCommand}
        bind = SUPER, F2, exec, ${browserCommand}
        bind = SUPER, F3, exec, ${fileManagerCommand}
        bind = SUPER, F10, exec, ${audio.playerCommand}
        bind = SUPER_SHIFT, M, exec, ${audio.managerCommand}
        bind = SUPER, W, exec, ${appLauncherCommand}

        # Move focus
        bind = SUPER, LEFT, movefocus, l
        bind = SUPER, RIGHT, movefocus, r
        bind = SUPER, UP, movefocus, u
        bind = SUPER, DOWN, movefocus, d
        bind = SUPER, H, movefocus, l
        bind = SUPER, L, movefocus, r
        bind = SUPER, K, movefocus, u
        bind = SUPER, J, movefocus, d

        # Move focused window
        bind = SUPER_SHIFT, LEFT, movewindow, l
        bind = SUPER_SHIFT, RIGHT, movewindow, r
        bind = SUPER_SHIFT, UP, movewindow, u
        bind = SUPER_SHIFT, DOWN, movewindow, d
        bind = SUPER_SHIFT, H, movewindow, l
        bind = SUPER_SHIFT, L, movewindow, r
        bind = SUPER_SHIFT, K, movewindow, u
        bind = SUPER_SHIFT, J, movewindow, d

        # Move focused window into/outo groUP
        bind = SUPER, G, togglegroUP,
        bind = SUPER_CONTROL, LEFT, changegroUPactive, b
        bind = SUPER_CONTROL, RIGHT, changegroUPactive, f
        bind = SUPER_CONTROL, H, changegroUPactive, b
        bind = SUPER_CONTROL, L, changegroUPactive, f
        bind = SUPER_CONTROL, LEFT, moveintogroUP, l
        bind = SUPER_CONTROL, RIGHT, moveintogroUP, r
        bind = SUPER_CONTROL, UP, moveintogroUP, u
        bind = SUPER_CONTROL, DOWN, moveintogroUP, d
        bind = SUPER_CONTROL, H, moveintogroUP, l
        bind = SUPER_CONTROL, L, moveintogroUP, r
        bind = SUPER_CONTROL, K, moveintogroUP, u
        bind = SUPER_CONTROL, J, moveintogroUP, d

        # Switch workspaces
        bind = ALT, TAB, workspace, previous
        bind = SUPER, 1, workspace, 1
        bind = SUPER, 2, workspace, 2
        bind = SUPER, 3, workspace, 3
        bind = SUPER, 4, workspace, 4
        bind = SUPER, 5, workspace, 5
        bind = SUPER, 6, workspace, 6
        bind = SUPER, 7, workspace, 7
        bind = SUPER, 8, workspace, 8
        bind = SUPER, 9, workspace, 9

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
        bind = SUPER_CONTROL, 1, movetoworkspacesilent, 1
        bind = SUPER_CONTROL, 2, movetoworkspacesilent, 2
        bind = SUPER_CONTROL, 3, movetoworkspacesilent, 3
        bind = SUPER_CONTROL, 4, movetoworkspacesilent, 4
        bind = SUPER_CONTROL, 5, movetoworkspacesilent, 5
        bind = SUPER_CONTROL, 6, movetoworkspacesilent, 6
        bind = SUPER_CONTROL, 7, movetoworkspacesilent, 7
        bind = SUPER_CONTROL, 8, movetoworkspacesilent, 8
        bind = SUPER_CONTROL, 9, movetoworkspacesilent, 9

        # Move/resize windows with mouse buttons
        bindm = SUPER, mouse:272, movewindow
        bindm = SUPER, mouse:273, resizewindow

        # Autostart
        exec-once = wl-configure-gtk
        exec-once = ${polkitAgent}
      '';
    };
  };
}
