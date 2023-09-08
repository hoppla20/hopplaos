{lib, ...}: {
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
      lf.enable = true;
      git = {
        enable = true;
        userName = "vincent.cui";
        userEmail = "privat@vincentcui.de";
      };
      nixvim.enable = true;
      emacs.enable = true;
    };
  };
}
