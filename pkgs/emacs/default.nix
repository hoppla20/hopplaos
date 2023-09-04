{pkgs, ...}:
pkgs.emacsWithPackagesFromUsePackage {
  config = ./config/emacs.el;
  package = pkgs.emacs-pgtk;

  defaultInitFile = true;
  alwaysEnsure = true;
  # alwaysTangle = false;

  extraEmacsPackages = epkgs:
    builtins.attrValues {
      inherit
        (epkgs)
        use-package
        ;
    };
  # override = self: super: {};
}
