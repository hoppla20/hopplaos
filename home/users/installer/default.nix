{...}: {
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
      direnv.enable = true;
      vscode.enable = true;
    };

    desktop = {
      enable = true;
      audio.enable = true;
      rofi.enable = true;
      wayland = {hyprland.enable = true;};
    };
  };
}
