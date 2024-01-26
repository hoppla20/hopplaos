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
      #tmux.enable = true;
      zoxide.enable = true;
      direnv.enable = true;
      lf.enable = true;
      ranger.enable = true;
      git = {
        enable = true;
        userName = lib.mkDefault "vincent.cui";
        userEmail = lib.mkDefault "privat@vincentcui.de";
      };
      #emacs.enable = true;
    };

    profiles = {
      server-management.enable = true;
    };
  };
}
