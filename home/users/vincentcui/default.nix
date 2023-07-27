{ ... }: {
  hopplaos = {
    programs = {
      gpg = {
        enable = true;
        gpg-agent.enable = true;
      };
      ssh = {
        enable = true;
        matchBlocks = { "gitlab-ssh.vincentcui.de" = { port = 9022; }; };
      };
      zsh.enable = true;
      direnv.enable = true;
      neovim.enable = true;
      vscode.enable = true;
      keepassxc.enable = true;
      office.enable = true;
      messangers.enable = true;
      lf.enable = true;
    };

    services = {
      syncthing.enable = true;
      nextcloud-client.enable = true;
    };

    desktop = {
      enable = true;
      audio.enable = true;
      rofi.enable = true;
      wayland.hyprland.enable = true;
    };
  };
}
