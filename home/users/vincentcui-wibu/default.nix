{lib, ...}: {
  imports = [../vincentcui];

  hopplaos = {
    programs = {
      git = {
        userName = lib.mkForce "Vincent Cui";
        userEmail = lib.mkForce "vincent.cui@wibu.com";
      };
    };
  };
}
