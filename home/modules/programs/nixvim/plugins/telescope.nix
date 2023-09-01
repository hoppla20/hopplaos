_: {
  programs.nixvim = {
    plugins = {
      telescope = {
        enable = true;
        extensions = {
          fzf-native.enable = true;
        };
        keymaps = {
          "<leader>fg" = "live_grep";
          "<C-p>" = "git_files";
        };
      };
    };
  };
}

