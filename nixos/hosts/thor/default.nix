{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  hopplaos = {
    users.vincentcui.enable = true;
    desktop = {
      enable = true;
      thunar.enable = true;
      wayland = {
        hyprland.enable = true;
        sway.enable = true;
      };
    };
  };
}
