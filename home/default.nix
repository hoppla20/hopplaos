{
  withSystem,
  inputs,
  self,
  ...
}: let
  inherit
    (self.lib)
    exportModulesRecursive
    listDirectoryModules
    ;
  inherit
    (inputs.nixpkgs.lib)
    cartesianProductOfSets
    nameValuePair
    mapAttrs
    ;
  inherit
    (inputs.flake-utils-plus.lib.internal)
    genAttrs'
    ;

  homeModules = exportModulesRecursive ./modules;
  extraModules = [
    inputs.nix-index-db.hmModules.nix-index
    inputs.hyprland.homeManagerModules.default
    inputs.nixvim.homeManagerModules.nixvim
  ];

  users = listDirectoryModules ./users;
  hosts = listDirectoryModules ./hosts;

  homeConfigs =
    genAttrs'
    (combination:
      nameValuePair "${combination.user}@${combination.host}" {
        imports =
          [
            users.${combination.user}
            hosts.${combination.host}
          ]
          ++ builtins.attrValues homeModules
          ++ extraModules;
      })
    (cartesianProductOfSets {
      user = builtins.attrNames users;
      host = builtins.attrNames hosts;
    });
in {
  flake = {
    homeModules = homeModules;
    homeConfigurations = homeConfigs;
  };
}
