_: {
  plugins = {
    treesitter = {
      enable = true;
      indent = true;
      folding = true;
    };
    treesitter-context = {
      enable = true;
      mode = "cursor";
      maxLines = 5;
      minWindowHeight = 25;
    };
    rainbow-delimiters.enable = true;
    treesitter-refactor = {
      enable = true;
      smartRename.enable = true;
      navigation.enable = true;
    };
  };
}
