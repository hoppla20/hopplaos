{lib, ...}: {
  imports = [../vincentcui-nogui];

  hopplaos = {
    programs = {
      vscode.enable = true;
      keepassxc.enable = true;
      office.enable = true;
      messangers.enable = true;

      # alacritty.enable = true;
      kitty.enable = true;
    };

    services = {
      syncthing.enable = lib.mkDefault true;
      nextcloud-client.enable = lib.mkDefault true;
    };

    desktop = {
      enable = true;
      audio.enable = true;
      rofi.enable = true;
      development.enable = true;
      wayland.hyprland.enable = true;
    };
  };
}
