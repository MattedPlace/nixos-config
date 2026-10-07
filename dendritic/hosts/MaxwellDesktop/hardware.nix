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

      boot = {
        initrd.availableKernelModules = [
          "nvme"
          "xhci_pci"
          "ahci"
          "usb_storage"
          "usbhid"
          "sd_mod"
        ];
        loader = {
          systemd-boot = {
            enable = true;
            configurationLimit = 10;
            editor = false;
          };
          efi.canTouchEfiVariables = true;
          efi.efiSysMountPoint = "/boot";
          timeout = 5; # Auto select time
        };

        # Boot options
        blacklistedKernelModules = [
          "iwlwifi"
        ];
        kernelParams = [
          "processor.max_cstate=5"
          "rcu_nocbs=0-11"
        ]; # Set processor.max_cstate to 5 to prevent random crashes

        kernelPackages = pkgs.linuxPackages_6_18;

        extraModulePackages = [
          config.boot.kernelPackages.rtl88x2bu
          #config.boot.kernelPackages.broadcom_sta
        ];

        supportedFilesystems = [ "ntfs" ];

      };

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

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
