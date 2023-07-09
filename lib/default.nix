{lib}: let
  inherit
    (lib.digga)
    flattenTree
    rakeLeaves
    ;
  inherit
    (lib)
    mapAttrs
    ;
in
  lib.makeExtensible (self: {
    exportModulesRecursive = dir:
      mapAttrs
      (path: import path)
      (flattenTree (rakeLeaves dir));
  })
