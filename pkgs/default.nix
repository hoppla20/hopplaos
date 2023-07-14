{
  perSystem = {
    pkgs,
    inputs',
    ...
  }: {
    packages = {
      repl = pkgs.callPackage ./repl {};
      install-system = pkgs.callPackage ./install-system {inherit inputs';};
    };
  };
}
