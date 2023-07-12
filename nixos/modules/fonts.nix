{
  pkgs,
  config,
  lib,
  ...
}: {
  fonts = {
    fonts = [
      (pkgs.nerdfonts.override
        {
          fonts = ["FiraCode" "JetBrainsMono"];
        })
    ];
  };
}
