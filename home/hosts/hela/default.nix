{
  hopplaos = {
    services.nextcloud-client.enable = false;

    hardware = {
      bluetooth.enable = false;
      monitors = [
        {
          name = "DP-2";
          value = {
            resolution = "1920x1080";
            refreshRate = 60;
            position = {
              x = 1920;
              y = 0;
            };
          };
        }
        {
          name = "DP-3";
          value = {
            resolution = "1920x1080";
            refreshRate = 60;
            position = {
              x = 0;
              y = 0;
            };
          };
        }
      ];
    };
  };
}
