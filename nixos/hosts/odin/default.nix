{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ./disko.nix
  ];

  hopplaos = {
    hardware = {
      cpu.manufacturer = "amd";
    };
    users.vincentcui.enable = true;
    desktop = {
      enable = true;
      thunar.enable = true;
      wayland = {
        hyprland.enable = true;
        sway.enable = true;
      };
    };
    boot = {
      enable = true;
      kernelModules.kvm.enable = true;
      grub.enable = true;
    };
  };
}
