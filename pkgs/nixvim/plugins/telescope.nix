_: {
  plugins = {
    telescope = {
      enable = true;
      defaults.theme = "dropdown";
      extensions.fzf-native.enable = true;
    };
    harpoon = {
      enable = true;
      tmuxAutocloseWindows = true;
      enterOnSendcmd = true;
    };
  };

  maps.normal = let
    findPrefix = "<leader>f";
    harpoonPrefix = "<leader>h";
    executePrefix = "<leader>e";
    silentAction = action: {
      silent = true;
      action = "<CMD>${action}<CR>";
    };
    harpoonModule = module: ":lua require('harpoon.${module}')";
  in {
    "<C-p>" = silentAction ":Telescope git_files";

    "${findPrefix}" = {desc = "find";};
    "${findPrefix}c" = silentAction ":Telescope commands";
    "${findPrefix}f" = silentAction ":Telescope find_files";
    "${findPrefix}g" = silentAction ":Telescope live_grep";
    "${findPrefix}m" = silentAction ":Telescope keymaps";

    "${harpoonPrefix}" = {desc = "harpoon";};
    "${harpoonPrefix}a" = silentAction "${harpoonModule "mark"}.add_file()";
    "${harpoonPrefix}m" = silentAction "${harpoonModule "ui"}.toggle_quick_menu()";
    "${harpoonPrefix}p" = silentAction "${harpoonModule "ui"}.nav_prev()";
    "${harpoonPrefix}n" = silentAction "${harpoonModule "ui"}.nav_next()";
    "${harpoonPrefix}t" = silentAction ":Telescope harpoon marks";

    "${harpoonPrefix}1" = silentAction "${harpoonModule "ui"}.nav_file(1)";
    "${harpoonPrefix}2" = silentAction "${harpoonModule "ui"}.nav_file(2)";
    "${harpoonPrefix}3" = silentAction "${harpoonModule "ui"}.nav_file(3)";
    "${harpoonPrefix}4" = silentAction "${harpoonModule "ui"}.nav_file(4)";
    "${harpoonPrefix}5" = silentAction "${harpoonModule "ui"}.nav_file(5)";
    "${harpoonPrefix}6" = silentAction "${harpoonModule "ui"}.nav_file(6)";
    "${harpoonPrefix}7" = silentAction "${harpoonModule "ui"}.nav_file(7)";
    "${harpoonPrefix}8" = silentAction "${harpoonModule "ui"}.nav_file(8)";
    "${harpoonPrefix}9" = silentAction "${harpoonModule "ui"}.nav_file(9)";

    "${executePrefix}" = {desc = "execute";};
    "${executePrefix}m" = silentAction "${harpoonModule "cmd-ui"}.toggle_quick_menu()";
    "${executePrefix}t" = silentAction "${harpoonModule "tmux"}.gotoTerminal('{down-of}')";
    "${executePrefix}e" = silentAction "${harpoonModule "tmux"}.sendCommand('{down-of}', 1)";

    "${executePrefix}1" = silentAction "${harpoonModule "tmux"}.sendCommand('{down-of}', 1)";
    "${executePrefix}2" = silentAction "${harpoonModule "tmux"}.sendCommand('{down-of}', 2)";
    "${executePrefix}3" = silentAction "${harpoonModule "tmux"}.sendCommand('{down-of}', 3)";
    "${executePrefix}4" = silentAction "${harpoonModule "tmux"}.sendCommand('{down-of}', 4)";
    "${executePrefix}5" = silentAction "${harpoonModule "tmux"}.sendCommand('{down-of}', 5)";
    "${executePrefix}6" = silentAction "${harpoonModule "tmux"}.sendCommand('{down-of}', 6)";
    "${executePrefix}7" = silentAction "${harpoonModule "tmux"}.sendCommand('{down-of}', 7)";
    "${executePrefix}8" = silentAction "${harpoonModule "tmux"}.sendCommand('{down-of}', 8)";
    "${executePrefix}9" = silentAction "${harpoonModule "tmux"}.sendCommand('{down-of}', 9)";
  };
}
