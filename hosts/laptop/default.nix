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
  imports =                                               # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    [(import ../../modules/desktop/gnomeTablet/default.nix)];      # desktop enviroment

  boot = {                                  # Boot options
    kernelPackages = pkgs.linuxPackages_latest;
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
    opengl = {
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
      driSupport32Bit = true;
    };
  };

  environment = {
    variables = {
      LIBVA_DRIVER_NAME = "i915";
    };
    systemPackages = with pkgs; [
      simple-scan
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
    blueman.enable = true;
    printing = {                            # Printing and drivers for TS5300
      enable = true;
    };
    avahi = {                               # Needed to find wireless printer
      enable = true;
      nssmdns = true;
      publish = {                           # Needed for detecting the scanner
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
    samba = {
      enable = true;
      shares = {
        share = {
          "path" = "/home/${user}";
          "guest ok" = "no";
          "read only" = "no";
        };
      };
      openFirewall = true;
    };
  };

  networking = {
    hostName = "maxLaptop";
    networkmanager.enable = true;
  };

  specialisation = {
    hyprland.configuration = {
      imports = [(import ../../modules/desktop/hyprland/default.nix)];
      home-manager.users.${user}.imports = [
        ../../modules/desktop/hyprland/home.nix #window manager
      ];
    };

    river.configuration = {
      imports = [(import ../../modules/desktop/river/default.nix)];
      home-manager.users.${user}.imports = [
        ../../modules/desktop/river/home.nix #window manager
      ];
    };

    sway.configuration = {
      imports = [(import ../../modules/desktop/sway/default.nix)];
      home-manager.users.${user}.imports = [
        ../../modules/desktop/sway/home.nix #window manager
      ];
    };

    bspwm.configuration = {
      imports = [(import ../../modules/desktop/bspwm/default.nix)];
      home-manager.users.${user}.imports = [
        ../../modules/desktop/bspwm/home.nix #window manager
      ];
    };

    kde.configuration = {
      imports = [(import ../../modules/desktop/kde/default.nix)];
      home-manager.users.${user}.imports = [
        ../../modules/desktop/kde/home.nix #window manager
      ];
    };
  };
}
