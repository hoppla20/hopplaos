{lib, ...}: {
  imports = [../vincentcui-nogui];

  hopplaos = {
    programs = {
      keepassxc.enable = true;
      office.enable = true;
      messangers.enable = true;
      anki.enable = true;
      nixvim-desktop.enable = true;
      kitty.enable = true;
      notetaking.enable = true;
    };

    services = {
      syncthing.enable = lib.mkDefault true;
      nextcloud-client.enable = lib.mkDefault true;
    };

    desktop = {
      enable = true;
      music.enable = true;
      development.enable = true;
      image-editing.enable = true;
    };
  };
}
