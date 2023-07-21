{config, ...}: {
  hopplaos.hardware = {
    monitors = [
      {
        name = "HDMI-A-1";
        value = {
          resolution = "2560x1080";
          refreshRate = 75;
          position = {
            x = 0;
            y = 420;
          };
        };
      }
      {
        name = "DP-1";
        value = {
          resolution = "1920x1080";
          refreshRate = 60;
          transform = "270";
          position = {
            x = 2560;
            y = 0;
          };
          background.file = "~/.config/wallpapers/wallpaper-${if config.hopplaos.desktop.darkTheme then "dark" else "light"}-90.jpg";
        };
      }
    ];
  };
}
