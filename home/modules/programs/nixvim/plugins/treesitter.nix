_: {
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        indent = true;
        folding = true;
      };
      treesitter-context.enable = true;
      treesitter-rainbow.enable = true;
      treesitter-refactor = {
        enable = true;
        smartRename.enable = true;
        navigation.enable = true;
      };
    };
  };
}

