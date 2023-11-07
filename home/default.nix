{
  lib,
  inputs,
  self,
  withSystem,
  ...
}: let
  inherit (self.lib) exportModulesRecursive listDirectoryModules;
  inherit (inputs.nixpkgs.lib) cartesianProductOfSets nameValuePair mapAttrs;
  inherit (inputs.flake-utils-plus.lib.internal) genAttrs';

  homeModules = exportModulesRecursive ./modules;
  extraModules = [
    inputs.nix-index-db.hmModules.nix-index
    inputs.hyprland.homeManagerModules.default
    inputs.base16.homeManagerModule
    inputs.spicetify-nix.homeManagerModules.default
  ];

  users = listDirectoryModules ./users;
  hosts = listDirectoryModules ./hosts;

  genHomeConfigs =
    genAttrs'
    (combination:
      nameValuePair "${combination.user}@${combination.host}" {
        imports =
          [users.${combination.user} hosts.${combination.host}]
          ++ builtins.attrValues homeModules
          ++ extraModules;
      })
    (cartesianProductOfSets {
      user = builtins.filter (u: u != "vincentcui-nogui") (builtins.attrNames users);
      host = builtins.attrNames hosts;
    });
in {
  flake = {
    inherit homeModules;
    homeConfigurations =
      genHomeConfigs
      // {
        nix-on-droid = {
          imports =
            [
              users.vincentcui-nogui
              {
                home = {
                  username = "nix-on-droid";
                  homeDirectory = "/data/data/com.termux.nix/files/home";
                };

                hopplaos.programs.gpg.enable = lib.mkForce false;
                hopplaos.programs.emacs.enable = lib.mkForce false;

                services.emacs.enable = lib.mkForce false;
              }
            ]
            ++ builtins.attrValues homeModules
            ++ extraModules;
        };
      };
  };
}
