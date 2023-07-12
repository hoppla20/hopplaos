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
    mkMerge
    mapAttrsToList
    concatStringsSep
    optionals
    optionalString
    ;
  inherit
    (desktopCfg)
    terminalCommand
    browserCommand
    editorCommand
    fileManagerCommand
    ;

  desktopCfg = config.hopplaos.desktop;
  cfg = desktopCfg.wayland.hyprland;
in let
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
in {
  options = {
    hopplaos.desktop.wayland.hyprland = {
      enable = mkEnableOption "Wayland - Hyprland";
    };
  };

  config = mkIf (desktopCfg.enable && cfg.enable) (mkMerge [
    {
      wayland.windowManager.hyprland = {
        enable = true;
        systemdIntegration = true;
        recommendedEnvironment = true;

        # use system package
        package = null;
        extraConfig = ''
          # Host specific monitors
          ${monitors}
          # Automatically add new monitors to the right
          monitor=,preferred,auto,1

          # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
          input {
            kb_layout = us
            kb_variant = altgr-intl
            kb_model = caps:escape
            kb_options =
            kb_rules =

            follow_mouse = 0

            touchpad {
                natural_scroll = true
            }

            sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
          }

          general {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more

            gaps_in = 5
            gaps_out = 20
            border_size = 2
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
            new_is_master = true
          }

          gestures {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            workspace_swipe = false
          }

          $mainMod = SUPER

          bind = $mainMod, RETURN, exec, ${terminalCommand}
          bind = $mainMod SHIFT, Q, killactive,

          # Move focues with mainMod + arrow keys
          bind = $mainMod, left, movefocus, l
          bind = $mainMod, right, movefocus, r
          bind = $mainMod, up, movefocus, u
          bind = $mainMod, down, movefocus, d
          bind = $mainMod, H, movefocus, l
          bind = $mainMod, L, movefocus, r
          bind = $mainMod, k, movefocus, u
          bind = $mainMod, j, movefocus, d

          # Switch workspaces with mainMod + [0-9]
          bind = $mainMod, 1, workspace, 1
          bind = $mainMod, 2, workspace, 2
          bind = $mainMod, 3, workspace, 3
          bind = $mainMod, 4, workspace, 4
          bind = $mainMod, 5, workspace, 5
          bind = $mainMod, 6, workspace, 6
          bind = $mainMod, 7, workspace, 7
          bind = $mainMod, 8, workspace, 8
          bind = $mainMod, 9, workspace, 9

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          bind = $mainMod SHIFT, 1, movetoworkspace, 1
          bind = $mainMod SHIFT, 2, movetoworkspace, 2
          bind = $mainMod SHIFT, 3, movetoworkspace, 3
          bind = $mainMod SHIFT, 4, movetoworkspace, 4
          bind = $mainMod SHIFT, 5, movetoworkspace, 5
          bind = $mainMod SHIFT, 6, movetoworkspace, 6
          bind = $mainMod SHIFT, 7, movetoworkspace, 7
          bind = $mainMod SHIFT, 8, movetoworkspace, 8
          bind = $mainMod SHIFT, 9, movetoworkspace, 9

          # Move/resize windows with mainMod + LMB/RMB and dragging
          bindm = $mainMod, mouse:272, movewindow
          bindm = $mainMod, mouse:273, resizewindow
        '';
      };
    }
    (mkIf desktopCfg.wayland.waybar.enable {
      systemd.user.services.waybar.Install.WantedBy = "hyprland-session.target";
    })
  ]);
}
