_: {
  programs.nixvim = {
    plugins = {
      neogit = {
        enable = true;
        integrations.diffview = true;
      };
    };
  };
}

