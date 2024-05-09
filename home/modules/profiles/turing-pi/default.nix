{
  self',
  lib,
  config,
  ...
}: let
  cfg = config.hopplaos.profiles.turing-pi;
in {
  options.hopplaos.profiles.turing-pi = {
    enable = lib.mkEnableOption "Turing Pi";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [self'.packages.tpi];
  };
}
