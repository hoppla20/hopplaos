{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkMerge mkIf;

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
          trashy
          ;
      };

      services = {
        printing = {
          enable = true;
          drivers = [pkgs.gutenprint pkgs.canon-cups-ufr2];
        };

        blueman.enable = config.hopplaos.hardware.bluetooth;
        dbus.enable = true;
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
      xdg.portal = {xdgOpenUsePortal = true;};

      specialisation = {
        dark.configuration = {
          home-manager.users.vincentcui.hopplaos.desktop.darkTheme = true;
        };
        light.configuration = {
          home-manager.users.vincentcui.hopplaos.desktop.darkTheme = false;
        };
      };
    }
    (mkIf cfg.thunar.enable {
      programs = {
        thunar = {
          enable = true;
          plugins = builtins.attrValues {
            inherit (pkgs.xfce) thunar-archive-plugin thunar-volman;
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
