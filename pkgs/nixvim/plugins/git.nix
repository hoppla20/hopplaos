{lib, ...}: let
  l = lib // builtins;
in {
  plugins = {
    neogit = {
      enable = true;
      integrations.diffview = true;
      kind = "auto";
      commitPopup.kind = "floating";
    };
  };
  maps.normal = let
    prefix = "<leader>g";
    silentAction = action: {
      silent = true;
      action = "<CMD>${action}<CR>";
    };
  in {
    "${prefix}" = {desc = "neogit";};
    "${prefix}g" = silentAction ":Neogit";
    "${prefix}f" = silentAction ":Neogit kind=floating";
  };
}
