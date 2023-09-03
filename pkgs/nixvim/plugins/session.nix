_: {
  plugins.auto-session = {
    enable = true;
    autoSave.enabled = true;
    autoRestore.enabled = false;
    autoSession = {
      enabled = true;
      createEnabled = true;
      useGitBranch = true;
      suppressDirs = ["/home/*/Workspace"];
      allowedDirs = ["/home/*/Workspace/**" "/etc/nixos"];
    };
    cwdChangeHandling.restoreUpcomingSession = true;
    sessionLens.loadOnSetup = true;
    extraOptions = {
      auto_session_enable_last_session = "vim.loop.cwd() == vim.loop.os_homedir() or vim.loop.cwd() == vim.loop.os_homedir() .. \"/Workspace\"";
    };
  };
  maps.normal = let
    prefix = "<leader>s";
    silentAction = action: {
      silent = true;
      action = "<CMD>${action}<CR>";
    };
  in {
    "${prefix}" = {desc = "sessions";};
    "${prefix}s" = silentAction ":SessionSave";
    "${prefix}r" = silentAction ":SessionRestore";
    "${prefix}d" = silentAction ":SessionDelete";
    "${prefix}S" = silentAction ":lua require('auto-session.session-lens').search_session()";
  };
}
