{
  pkgs,
  inputs,
  ...
}:
pkgs.emacsWithPackagesFromUsePackage {
  package = pkgs.emacs-pgtk;

  config = "${inputs.hoppla-emacs}/etc/hoppla.org";
  defaultInitFile = false;
  alwaysEnsure = true;
  alwaysTangle = false;

  extraEmacsPackages = epkgs:
    builtins.attrValues {
      inherit
        (epkgs)
        use-package
        no-littering # is configured before loading use-package
        ;
    };
}
