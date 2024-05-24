{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption mkEnableOption mkIf;

  cfg = config.hopplaos.wibu.share;

  shareCredentialsFile = "/etc/wibu/smbcredentials";

  ownerUid = config.users.users.vincentcui.uid;
  groupUid = config.users.groups.${config.users.users.vincentcui.group}.gid;
in {
  options = {
    hopplaos.wibu.share = {
      enable = mkEnableOption "AutoFS";
      host = mkOption {
        type = types.str;
        default = "srv-ka-file01";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.cifs-utils pkgs.samba];

    services.autofs = {
      enable = true;
      timeout = 600;
      debug = true;
      autoMaster = let
        shareConf = pkgs.writeShellScript "wibu-map-share" ''
          # $Id$
          # This file must be executable to work! chmod 755!
          key="$1"
          valid_keys=("${cfg.host}")
          if [[ ! " ''${valid_keys[*]} " =~ " $key " ]]; then
            exit 0
          fi

          # Note: create a cred file for each windows/Samba-Server in your network
          #       which requires password authentification.  The file should contain
          #       exactly two lines:
          #          username=user
          #          password=*****
          #       Please don't use blank spaces to separate the equal sign from the
          #       user account name or password.
          creds=${shareCredentialsFile}
          mountopts="-fstype=cifs,file_mode=0644,dir_mode=0755,uid=${toString ownerUid},gid=${toString groupUid}"
          if [ -f "$creds" ]; then
              opts="$mountopts,credentials=$creds"
              smbopts="-A $creds"
          else
              opts="$mountopts,guest"
              smbopts="-N"
          fi

          SMBCLIENT="${pkgs.samba}/bin/smbclient"
          [ -x $SMBCLIENT ] || exit 1

          $SMBCLIENT $smbopts -gL $key 2>/dev/null \
            | ${pkgs.gawk}/bin/awk -v key="$key" -v opts="$opts" -F'|' -- '
                BEGIN   { ORS=""; first=1 }
                /Disk/  { if (first) { print opts; first=0 };
                          gsub(/ /, "\\ ", $2);
                          sub(/\$/, "\\$", $2);
                          print " \\\n\t /" $2, "://" key "/" $2 }
                END     { if (!first) print "\n"; else exit 1 }
                '
        '';
      in ''
        /share/wibu ${shareConf} --timeout 60 --ghost
      '';
    };
  };
}
