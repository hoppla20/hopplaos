{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption mkEnableOption mkIf mkMerge;

  inherit (pkgs) fetchurl;

  cfg = config.hopplaos.wibu;
in {
  options.hopplaos.wibu = {enable = mkEnableOption "WIBU";};

  config = mkIf cfg.enable {
    security.pki.certificateFiles = [
      ./certificates/gsrsaovsslca2018.crt
      (fetchurl {
        url = "https://intranet.wibu.local/WIBU_Root_CA_II.crt";
        sha256 = "0vql98m89jhxm1lgm0hx2zw8x0dqnbi69ynv17hlrw99d9i4gdr5";
      })
      (fetchurl {
        url = "https://intranet.wibu.local/WIBU_HTTPS_CA_II.crt";
        sha256 = "16lgib95a7qddanmc6fvf5pxd96a77bfcy67ikfd8271xmjic3hr";
      })
    ];

    services.teamviewer.enable = true;

    environment.systemPackages = builtins.attrValues {
      inherit
        (pkgs)
        zoom-us
        ;
    };
  };
}
