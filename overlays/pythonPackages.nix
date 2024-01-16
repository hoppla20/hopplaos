{inputs, ...}: {
  flake.overlays.pythonPackages = final: prev: let
    packageOverrides = pfinal: pprev: {
      type-config = pprev.buildPythonPackage rec {
        pname = "type_config";
        version = "1.3.0";
        pyproject = true;

        src = prev.fetchPypi {
          inherit pname version;
          hash = "sha256-fd2agatkurOnDTSjt8BzWownM1CNBQWQ7Rq8f6gO8+A=";
        };

        nativeBuildInputs = [pprev.setuptools];
      };
    };
  in {
    # python3 = prev.python3.override {inherit packageOverrides;};

    # markdown2anki = final.python3Packages.buildPythonApplication rec {
    #   pname = "markdown2anki";
    #   version = "0.2.0";
    #   pyproject = true;
    #
    #   src = prev.fetchPypi {
    #     inherit pname version;
    #     hash = "sha256-gu9AGvXwOLTa3AF+QejkNiEbK2cOzNANHG0L9xFgMyM=";
    #   };
    #
    #   nativeBuildInputs = [
    #     final.python3.pkgs.setuptools
    #     final.python3.pkgs.setuptools-scm
    #   ];
    #   propagatedBuildInputs = builtins.attrValues {
    #     inherit
    #       (final.python3.pkgs)
    #       mistune
    #       pygments
    #       type-config
    #       requests
    #       python-frontmatter
    #       ;
    #   };
    # };
  };
}
