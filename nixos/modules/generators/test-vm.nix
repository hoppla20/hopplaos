{
  pkgs,
  config,
  lib,
  modulesPath,
  ...
}: let
  cfg = config.hopplaos.generators.test-vm;

  inherit
    (lib)
    types
    mkOption
    mkForce
    ;
in {
  options = {
    hopplaos.generators.test-vm = {
      diskSize = mkOption {
        type = types.int;
        default = 10240;
      };
    };
  };

  config = {
    formatConfigs.qcow = {config, ...}: {
      system.build.qcow = mkForce (import "${toString modulesPath}/../lib/make-disk-image.nix" {
        inherit lib config pkgs;
        diskSize = cfg.diskSize;
        format = "qcow2";
        partitionTableType = "efi";
        touchEFIVars = true;
        #postVM = '''';
      });
      services.qemuGuest.enable = true;
    };
  };
}
