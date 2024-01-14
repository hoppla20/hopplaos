{lib, ...}: {
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
}
