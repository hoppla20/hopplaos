{
  pkgs,
  config,
  lib,
  homeUsers,
  ...
}: let
  cfg = config.hopplaos.users.vincentcui;

  inherit
    (lib)
    types
    mkOption
    mkEnableOption
    mkIf
    ;
in {
  options.hopplaos.users.vincentcui = {
    enable = mkEnableOption "Users: Vincent Cui";
    hmUser = mkOption {
      type = types.str;
      default = "vincentcui@${config.networking.hostName}";
    };
  };

  config = mkIf cfg.enable {
    users.users.vincentcui = {
      hashedPassword = "$6$rounds=4096$BGIzgpigyvSnrnak$dOv/C2.bZjDqWYvPTic/rf6nIrvUDFmBuOmvQLzTNjSdm28xQBF7JSnIxlXTpdauAuPZQbSxRvJ18grEmg/Pd0";
      description = "Vincent Cui";
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "video"
        "audio"
        "networkmanager"
        "libvirtd"
        "docker"
        "tss"
        "nitrokey"
        "lp"
      ];
      openssh.authorizedKeys.keyFiles = lib.filesystem.listFilesRecursive ./ssh;
    };

    home-manager.users.vincentcui = homeUsers.${cfg.hmUser};

    security.sudo.extraRules = [
      {
        users = ["vincentcui"];
        commands = [
          {
            command = "${pkgs.nixos-rebuild}/bin/nixos-rebuild";
            options = ["SETENV" "NOPASSWD"];
          }
        ];
      }
    ];
  };
}
