{
  flake.modules.nixos.g15 = {
    fileSystems."/" =
      {
        device = "/dev/disk/by-label/NIXROOT";
        fsType = "ext4";
      };

    fileSystems."/boot" =
      {
        device = "/dev/disk/by-label/NIXBOOT";
        fsType = "vfat";
        options = [ "fmask=0022" "dmask=0022" ];
      };

    swapDevices = [{
      device = "/swapfile";
      size = 16 * 1024; #16 GB
    }];
  };
}
