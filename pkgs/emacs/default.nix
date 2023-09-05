{
  pkgs,
  inputs,
  ...
}:
pkgs.emacsWithPackagesFromUsePackage {
  package = pkgs.emacs-pgtk;

  config = "${inputs.hoppla-emacs}/config.org";
  defaultInitFile = false;
  alwaysEnsure = true;
  alwaysTangle = false;

  extraEmacsPackages = epkgs:
    builtins.attrValues {
      inherit
        (epkgs)
        use-package
        ;
    };
}
