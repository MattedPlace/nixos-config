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
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
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
  };

  gnome.enable = true;
  laptop.enable = true;

  hardware = {                         # Used for scanning with Xsane
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
    cpu.intel.updateMicrocode = false;
    nvidia = {
      prime = {
        offload.enable = true;
      # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
        intelBusId = "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
        nvidiaBusId = "PCI:1:0:0";
      };
      modesetting.enable = true;
    };
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
       # vaapiIntel
      #  vaapiVdpau
        libvdpau-va-gl
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva
     #   vaapiIntel
      ];
    };
  };

  environment = {

    variables = {
      LIBVA_DRIVER_NAME = "i915";
    };
    systemPackages = with pkgs; [
      simple-scan
      brightnessctl
      nvidia-offload
    ];
  };

  programs = {                              # No xbacklight, this is the alterantive
    dconf.enable = true;
    light.enable = true;
  };

  services = {
    xserver.videoDrivers = [ "nvidia" ];
    #logind.lidSwitch = "ignore";           # Laptop does not go to sleep when lid is closed
  };

  networking = {
    hostName = "MaxwellLaptop";
    networkmanager.enable = true;
  };
}
