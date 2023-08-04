{lib}: let
  inherit (lib.digga) flattenTree rakeLeaves;
  inherit (builtins) pathExists readDir;
  inherit (lib) mapAttrs filterAttrs;
in {
  exportModulesRecursive = dir:
    mapAttrs (_: import) (flattenTree (rakeLeaves dir));

  listDirectoryModules = dir: let
    hostDirectories =
      filterAttrs
      (name: type:
        type == "directory" && pathExists (dir + "/${name}/default.nix"))
      (readDir dir);
  in
    mapAttrs (name: _: (toString (dir + "/${name}"))) hostDirectories;
}
