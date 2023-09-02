{lib, ...}: let
  l = lib // builtins;
in {
  plugins.neo-tree = {
    enable = true;
    popupBorderStyle = "rounded";
    filesystem = {
      followCurrentFile.enabled = true;
      hijackNetrwBehavior = "open_current";
      useLibuvFileWatcher = true;
    };
  };
  maps.normal = let
    prefix = "<leader>t";
    silentAction = action: {
      silent = true;
      action = "<CMD>${action}<CR>";
    };
  in {
    "${prefix}" = {desc = "neotree";};
    "${prefix}t" = silentAction ":Neotree position=left toggle";
    "${prefix}f" = silentAction ":Neotree position=float toggle";
    "${prefix}s" = silentAction ":Neotree focus";
  };
}
