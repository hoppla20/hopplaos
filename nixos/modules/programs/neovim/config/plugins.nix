{...}: {
  lualine = {
    enable = true;
    theme = "catppuccin";
  };
  barbar = {
    enable = true;
    highlightAlternate = true;
    hide = {
      alternate = false;
      current = false;
      extensions = false;
      inactive = false;
      visible = false;
    };
  };
  telescope = {
    enable = true;
    extensions = {
      fzy-native = {
        enable = true;
        overrideGenericSorter = true;
        overrideFileSorter = true;
      };
      project-nvim.enable = true;
    };
  };
  dashboard = {
    enable = true;
    hideStatusline = true;
    hideTabline = true;
  };
  endwise.enable = true;
  floaterm = {
    enable = true;
    wintype = "float";
    width = 0.6;
    height = 0.6;
    position = "center";
    autoclose = 0;
    autohide = 2;
  };
  indent-blankline = {
    enable = true;
    showCurrentContext = true;
    showCurrentContextStart = true;
  };
  intellitab.enable = true;
  vim-bbye.enable = true;
  vim-matchup = {
    enable = true;
    treesitterIntegration.enable = true;
  };
  which-key = {
    enable = true;
    plugins = {
      marks = true;
      registers = true;
      presets = {
        operators = true;
        motions = true;
        textObjects = true;
        windows = true;
        nav = true;
        z = true;
        g = true;
      };
    };
  };
  treesitter.enable = true;
  treesitter-context.enable = true;
  treesitter-rainbow.enable = true;
  treesitter-refactor = {
    enable = true;
    smartRename.enable = true;
    highlightDefinitions.enable = true;
  };
  nix.enable = true;
  lsp = {
    enable = true;
    servers = {
      nil_ls = {
        enable = true;
        settings.formatting.command = ["alejandra"];
      };
      pylsp.enable = true;
      clangd.enable = true;
      yamlls.enable = true;
    };
  };
  lsp-format.enable = true;
  lsp-lines.enable = true;
  nvim-lightbulb.enable = true;
  trouble.enable = true;
  inc-rename.enable = true;
  fugitive.enable = true;
  gitgutter.enable = true;
  coq-nvim = {
    enable = true;
    installArtifacts = true;
    recommendedKeymaps = true;
  };
  coq-thirdparty = {
    enable = true;
    sources = [
      { src = "builtin/c"; }
      { src = "builtin/css"; }
      { src = "builtin/html"; }
      { src = "builtin/js"; }
      { src = "builtin/php"; }
      { src = "builtin/syntax"; }
    ];
  };
}
