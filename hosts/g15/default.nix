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

  boot = {
    loader = { 
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
	useOSProber = true;
      };
    };
    kernelParams = [ "nvidia-drm.modeset=1" "nvidia_drm.fbdev=1" ];
    blacklistedKernelModules = [ "nouveau" ];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  gnome.enable = true;
  laptop.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    graphics = {
      enable = true;
    };
    nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        # sync.enable = true;
        amdgpuBusId = "PCI:6:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
    ];
  };

  networking = {
    hostName = "MaxwellG15";
    networkmanager.enable = true;
  };
}
