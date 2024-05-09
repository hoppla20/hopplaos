{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkMerge mkIf;

  cfg = config.hopplaos.services.cache;
in {
  options = {
    hopplaos.services.cache = {
      serve = mkEnableOption "Cache serve";
    };
  };

  config = mkIf cfg.serve {
    services = {
      nix-serve = {
        enable = true;
        secretKeyFile = "/var/nix/cache-priv-key.pem";
      };

      nginx = {
        enable = true;
        recommendedProxySettings = true;
        virtualHosts = {
          "thor.tail6a5b6.ts.net" = {
            locations."/".proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
          };
        };
      };
    };
  };
}
