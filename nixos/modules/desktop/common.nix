{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    mkEnableOption
    mkMerge
    mkIf
    ;

  cfg = config.hopplaos.desktop;
in {
  options = {
    hopplaos.desktop = {
      enable = mkEnableOption "HopplaOS Desktop";
      thunar.enable = mkEnableOption "Thunar Filemanager";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = builtins.attrValues {
        inherit
          (pkgs)
          adwaita-qt
          adwaita-qt6
          ;
      };
      services = {
        blueman.enable = true;
        dbus.enable = true;
        gnome.gnome-keyring.enable = true;
        pipewire = {
          enable = true;
          alsa.enable = true;
          pulse.enable = true;
          wireplumber.enable = true;
        };
        xserver = {
          enable = true;
          libinput.enable = true;
          displayManager.gdm.enable = true;
        };
      };
      xdg.portal = {
        xdgOpenUsePortal = true;
      };
    }
    (mkIf cfg.thunar.enable {
      programs = {
        thunar = {
          enable = true;
          plugins = builtins.attrValues {
            inherit
              (pkgs.xfce)
              thunar-archive-plugin
              thunar-volman
              ;
          };
        };
        file-roller.enable = true;
      };
      services = {
        gvfs.enable = true;
        tumbler.enable = true;
      };
    })
  ]);
}
