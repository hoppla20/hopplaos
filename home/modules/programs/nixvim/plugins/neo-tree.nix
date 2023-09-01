_: {
  programs.nixvim = {
    plugins.neo-tree = {
      enable = true;
      popupBorderStyle = "rounded";
      filesystem.followCurrentFile = true;
    };
  };
}

