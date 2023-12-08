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
              end = "2GiB";
              bootable = true;
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["defaults"];
              };
            }
            {
              name = "luks";
              start = "2GiB";
              end = "100%";
              content = {
                type = "luks";
                name = "crypted";
                extraOpenArgs = ["--allow-discards"];
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
              };
            }
          ];
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          swap = {
            size = "16G";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };
          nixos = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = ["defaults"];
            };
          };
        };
      };
    };
  };
}
