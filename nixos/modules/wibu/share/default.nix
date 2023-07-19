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
    ;

  cfg = config.hopplaos.wibu.share;

  shareCredentialsFile = "/etc/wibu/smbcredentials";
in {
  options = {
    hopplaos.wibu.share = {
      enable = mkEnableOption "AutoFS";
      host = mkOption {
        type = types.str;
        default = "srv-ka-file";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.cifs-utils
      pkgs.samba
    ];

    services.autofs = {
      enable = true;
      timeout = 600;
      debug = true;
      autoMaster = let
        shareConf = pkgs.writeShellScript "wibu-map-share" ''
          # $Id$
          # This file must be executable to work! chmod 755!
          key="$1"
          # Note: create a cred file for each windows/Samba-Server in your network
          #       which requires password authentification.  The file should contain
          #       exactly two lines:
          #          username=user
          #          password=*****
          #       Please don't use blank spaces to separate the equal sign from the
          #       user account name or password.
          creds=${shareCredentialsFile}
          mountopts="-fstype=cifs"
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
            | /nix/store/49q1zfhkan4k0rqyxfhj512nw2wwngsf-gawk-5.2.1/bin/awk -v key="$key" -v opts="$opts" -F'|' -- '
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
