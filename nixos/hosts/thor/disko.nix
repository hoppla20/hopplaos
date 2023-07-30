{
  disko.devices = {
    disk = {
      nvme0n1 = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "table";
          format = "gpt";
          partitions = [
            {
              name = "ESP";
              start = "1MiB";
              end = "1GiB";
              bootable = true;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["defaults"];
              };
            }
            {
              name = "swap";
              start = "1GiB";
              end = "33GiB";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            }
            {
              name = "nixos";
              start = "33GiB";
              end = "333GiB";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = ["defaults"];
              };
            }
            {
              name = "storage";
              start = "333GiB";
              end = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/storage";
                mountOptions = ["defaults"];
              };
            }
          ];
        };
      };
    };
  };
}
