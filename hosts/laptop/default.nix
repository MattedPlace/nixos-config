#
#  Specific system configuration settings for laptop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./laptop
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       ├─ ./desktop
#       │   └─ ./bspwm/gnomeTablet/river/sway etc
#       │      └─ default.nix
#       └─ ./hardware
#           └─ default.nix
#

{ config, pkgs, user, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot = {                                  # Boot options
    loader = {                              # EFI Boot
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      systemd-boot = {
        enable = true;
        configurationLimit = 2;
      };
      timeout = 5;                          # Grub auto select time
    };
    kernelParams = [ "i915.force_probe=7d55" "nvidia_drm.fbdev=1" ];
    blacklistedKernelModules = [ "nouveau" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  gnome.enable = true;
  laptop.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    cpu.intel.updateMicrocode = false;
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        # sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        intel-media-driver
        intel-vaapi-driver
        nvidia-vaapi-driver
      ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      brightnessctl
    ];
  };

  programs = {
    dconf.enable = true;
    light.enable = true;
  };

  networking = {
    hostName = "MaxwellLaptop";
    networkmanager.enable = true;
  };
}
