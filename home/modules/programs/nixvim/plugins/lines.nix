_: {
  programs.nixvim = {
    plugins = {
      lualine.enable = true;
      barbar = {
        enable = true;
        keymaps = {
          silent = true;
          previous = "<A-,>";
          next = "<A-.>";
          movePrevious = "<A-<>";
          moveNext = "<A->>";
          pin = "<A-p>";
          close = "<A-q>";
          pick = "<A-s>";
          goTo1 = "<A-1>";
          goTo2 = "<A-2>";
          goTo3 = "<A-3>";
          goTo4 = "<A-4>";
          goTo5 = "<A-5>";
          goTo6 = "<A-6>";
          goTo7 = "<A-7>";
          goTo8 = "<A-8>";
          goTo9 = "<A-9>";
          orderByBufferNumber = "<leader>bb";
          orderByDirectory = "<leader>bd";
          orderByLanguage = "<leader>bl";
          orderByWindowNumber = "<leader>bw";
        };
      };
    };
  };
}

