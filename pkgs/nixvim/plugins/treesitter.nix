_: {
  plugins = {
    treesitter = {
      enable = true;
      indent = true;
      folding = true;
    };
    treesitter-context.enable = true;
    rainbow-delimiters.enable = true;
    treesitter-refactor = {
      enable = true;
      smartRename.enable = true;
      navigation.enable = true;
    };
  };
}
