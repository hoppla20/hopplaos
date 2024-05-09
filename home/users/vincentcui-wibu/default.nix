{
  lib,
  pkgs,
  ...
}: {
  imports = [../vincentcui];

  hopplaos = {
    desktop.video-editing.enable = true;
    programs = {
      git = {
        userName = lib.mkForce "Vincent Cui";
        userEmail = lib.mkForce "vincent.cui@wibu.com";
      };
    };
  };

  home.packages = builtins.attrValues {
    inherit
      (pkgs)
      mattermost-desktop
      ;
  };
}
