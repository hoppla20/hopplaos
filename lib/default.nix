{lib}: let
  l = lib // builtins;
in {
  exportModulesRecursive = dir:
    l.mapAttrs (_: path: import path) (l.digga.flattenTree (l.digga.rakeLeaves dir));

  listDirectoryModules = dir: let
    hostDirectories =
      l.filterAttrs
      (name: type:
        type == "directory" && l.pathExists (dir + "/${name}/default.nix"))
      (l.readDir dir);
  in
    l.mapAttrs (name: _: (toString (dir + "/${name}"))) hostDirectories;

  removeFromToplevel = key: cursor: value: let
    toplevel = cursor == [];
  in
    l.attrsets.unionOfDisjoint
    (l.removeAttrs value [key])
    (value.key or {});

  hoistStrings = from: to: cursor: let
    toplevel = cursor == [];
    concatMapAttrsWith = merge: f:
      l.flip l.pipe [
        (l.mapAttrs f)
        l.attrValues
        (l.foldl' merge {})
      ];
    mergeAttrsButConcatOn = key: x: y:
      x
      // y
      // {
        ${key} = builtins.concatStringsSep "\n" (builtins.catAttrs key [x y]);
      };
  in
    concatMapAttrsWith (mergeAttrsButConcatOn (
      if toplevel
      then to
      else from
    ))
    (file: value:
      if ! value ? ${from}
      then {${file} = value;}
      else {
        ${file} = removeAttrs value [from];
        # top level ${from} declarations are omitted from merging
        ${
          if toplevel
          then to
          else from
        } =
          value.${from};
      });
}
