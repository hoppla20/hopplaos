{
  hopplaos = {
    users.vincentcui.enable = true;
    desktop = {
      enable = true;
      thunar.enable = true;
      wayland = {
        sway.enable = false;
        hyprland.enable = true;
      };
    };
    boot = {
      enable = true;
      grub = {
        enable = true;
        vmConfig = true;
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      autoResize = true;
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/ESP";
      fsType = "vfat";
    };
  };
}
