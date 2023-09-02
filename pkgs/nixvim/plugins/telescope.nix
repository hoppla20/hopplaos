_: {
  plugins = {
    telescope = {
      enable = true;
      defaults.theme = "dropdown";
      extensions.fzf-native.enable = true;
    };
  };

  maps.normal = let
    prefix = "<leader>f";
    silentAction = action: {
      silent = true;
      action = "<CMD>${action}<CR>";
    };
  in {
    "<C-p>" = silentAction ":Telescope find_files";

    "${prefix}" = {desc = "find";};
    "${prefix}c" = silentAction ":Telescope commands";
    "${prefix}f" = silentAction ":Telescope find_files";
    "${prefix}g" = silentAction ":Telescope live_grep";
    "${prefix}m" = silentAction ":Telescope keymaps";
  };
}
