{inputs, ...}: {
  perSystem = {
    pkgs,
    inputs',
    system,
    ...
  }: {
    packages = let
      nixvim = darkTheme: let
        module = import ./nixvim;
      in
        inputs'.nixvim.legacyPackages.makeNixvimWithModule {
          pkgs = import inputs.unstable {
            inherit system;
            config.allowUnfree = true;
          };
          module = {
            imports = [module];
            colorschemes = {
              inherit darkTheme;
            };
          };
        };
    in {
      repl = pkgs.callPackage ./repl {};
      install-system = pkgs.callPackage ./install-system {inherit inputs';};
      run-test-vm = pkgs.callPackage ./run-test-vm {};

      nixvim-dark = nixvim true;
      nixvim-light = nixvim false;

      emacsWithPackages = pkgs.callPackage ./emacs {};
    };
  };
}
