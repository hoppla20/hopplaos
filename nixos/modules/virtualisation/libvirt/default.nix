{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit
    (lib)
    types
    mkOption
    mkEnableOption
    mkIf
    mkMerge
    ;

  cfg = config.hopplaos.virtualisation.libvirt;
in {
  options.hopplaos.virtualisation.libvirt = {
    enable = mkEnableOption "Libvirt";
  };

  config = mkIf cfg.enable {
    hopplaos.boot.kernelModules.kvm.enable = true;

    virtualisation = {
      libvirtd = {
        enable = true;
        onBoot = "ignore";
      };

      multipass.enable = true;
    };

    environment.systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        virt-manager
        virt-viewer
        virtiofsd
        #libguestfs-with-appliance
        ;
    };

    # vagrant
    services.nfs.server.enable = true;
    security.sudo.extraConfig = ''
      Cmnd_Alias VAGRANT_CHOWN = ${pkgs.coreutils}/bin/chown 0\:0 /tmp/vagrant*
      Cmnd_Alias VAGRANT_MV = ${pkgs.coreutils}/bin/mv -f /tmp/vagrant* /etc/exports
      Cmnd_Alias VAGRANT_START = ${pkgs.systemd}/bin/systemctl start --no-pager nfs-server
      Cmnd_Alias VAGRANT_STATUS = ${pkgs.systemd}/bin/systemctl status --no-pager nfs-server
      Cmnd_Alias VAGRANT_APPLY = ${pkgs.nfs-utils}/bin/exportfs -ar
      %wheel ALL=(root) NOPASSWD: VAGRANT_CHOWN, VAGRANT_MV, VAGRANT_START, VAGRANT_STATUS, VAGRANT_APPLY
    '';
  };
}
