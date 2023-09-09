{
  config,
  lib,
  ...
}: let
  cfg = config.hopplaos.cross-arch;
in {
  options.hopplaos.cross-arch.enable = lib.mkEnableOption "Cross/Qemu native compilation";

  config = lib.mkIf cfg.enable {
    boot.binfmt.emulatedSystems = ["aarch64-linux"];
  };
}
