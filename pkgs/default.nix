{
  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    packages = {
      repl = pkgs.callPackage ./repl {};
      install-system = pkgs.callPackage ./install-system {inherit inputs';};
      run-test-vm = pkgs.callPackage ./run-test-vm {};
    };
  };
}
