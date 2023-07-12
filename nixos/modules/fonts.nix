{
  pkgs,
  config,
  lib,
  ...
}: {
  fonts = {
    fonts = [
      pkgs.custom-nerdfonts
    ];
  };
}
