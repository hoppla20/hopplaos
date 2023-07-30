{self', ...}: {
  hopplaos = {
    users.vincentcui = {
      enable = true;
      hmUser = "installer@installer";
    };
    desktop = {
      enable = true;
      thunar.enable = true;
      wayland = {hyprland.enable = true;};
    };
    installer.enable = true;
  };

  environment.systemPackages = [self'.packages.install-system];
}
