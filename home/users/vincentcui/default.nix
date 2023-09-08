{
  self',
  lib,
  ...
}: {
  hopplaos = {
    programs = {
      gpg = {
        enable = true;
        gpg-agent.enable = true;
      };
      ssh = {
        enable = true;
        matchBlocks = {"gitlab-ssh.vincentcui.de" = {port = 9022;};};
      };
      zsh.enable = true;
      tmux.enable = true;
      direnv.enable = true;
      vscode.enable = true;
      keepassxc.enable = true;
      office.enable = true;
      messangers.enable = true;
      lf.enable = true;
      git = {
        enable = true;
        userName = "vincent.cui";
        userEmail = "privat@vincentcui.de";
      };
      nixvim.enable = true;
      emacs.enable = true;
      notetaking.enable = true;
    };

    services = {
      syncthing.enable = lib.mkDefault true;
      nextcloud-client.enable = lib.mkDefault true;
    };

    desktop = {
      enable = true;
      audio.enable = true;
      rofi.enable = true;
      wayland.hyprland.enable = true;
    };
  };
}
