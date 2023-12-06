{inputs, ...}: {
  perSystem = {
    pkgs,
    inputs',
    system,
    ...
  }: {
    packages = {
      repl = pkgs.callPackage ./repl {};
      install-system = pkgs.callPackage ./install-system {inherit inputs';};
      run-test-vm = pkgs.callPackage ./run-test-vm {};
      emacsWithPackages = pkgs.callPackage ./emacs {inherit inputs;};
    };
  };
}
