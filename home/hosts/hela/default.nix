{
  hopplaos = {
    services.nextcloud-client.enable = false;

    hardware = {
      bluetooth.enable = false;
      monitors = [
        {
          name = "DP-2";
          value = {
            resolution = "3440x1440";
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
