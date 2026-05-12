{
  flake.modules.nixos.desktop =
    {
      config,
      lib,
      modulesPath,
      pkgs,
      ...
    }:

    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      boot = {
        # Boot options
        blacklistedKernelModules = [
          "iwlwifi"
        ];
        kernelParams = [
          "processor.max_cstate=5"
          "rcu_nocbs=0-11"
        ]; # Set processor.max_cstate to 5 to prevent random crashes

        kernelPackages = pkgs.linuxPackages_latest;

        supportedFilesystems = [ "ntfs" ];

        loader = {
          systemd-boot = {
            enable = true;
            configurationLimit = 5;
          };
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
          };
          timeout = 5; # Auto select time
        };
      };
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      fileSystems."/" = {
        device = "/dev/disk/by-uuid/daec31c1-3fd9-4df5-b234-c65673485d90";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/7C61-1283";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

    };
}
