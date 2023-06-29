#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./laptop
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       ├─ ./desktop
#       │   ├─ ./bspwm
#       │   │   └─ default.nix
#       │   └─ ./virtualisation
#       │       └─ docker.nix
#       └─ ./hardware
#           └─ default.nix
#

{ config, pkgs, user, ... }:

{
  imports =                                               # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    [(import ../../modules/desktop/gnomeTablet/default.nix)];  # Window Manager
   # [(import ../../modules/desktop/virtualisation/docker.nix)] ++  # Docker
   # (import ../../modules/hardware);                      # Hardware devices

  boot = {                                  # Boot options
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
    "i915.enable_fbc=1" # Enable framebuffer compression for power saving
    "i915.enable_psr=1" # Enable panel self refresh for power saving
    "intel_idle.max_cstate=1" # Limit the maximum C-state for the CPU for power saving
    "intel_pstate=disable" # Disable the intel_pstate driver to use the acpi-cpufreq driver instead
    ];
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

  hardware = {
    cpu.intel.updateMicrocode = false;
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        libvdpau-va-gl
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        libva
        vaapiIntel
      ];
      driSupport32Bit = true;
    };
    bluetooth.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
    ];
    variables = {
      LIBVA_DRIVER_NAME = "i915";
    };
  };

  programs = {                              # No xbacklight, this is the alterantive
    dconf.enable = true;
    light.enable = true;
  };

  services = {
    xserver.videoDrivers = [ "intel" ];
    blueman.enable = true;
    udev.extraRules = ''
      ACTION=="add|change", KERNEL=="event[0-9]*", ENV{ID_PATH}=="platform-i8042-serio-0", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      ACTION=="add|change", KERNEL=="event[0-9]*", ENV{ID_PATH}=="platform-i8042-serio-1", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      ACTION=="add|change", KERNEL=="event[0-9]*", ENV{ID_PATH}=="pci-0000:00:1f.0-platform-VPC2004:00", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';
  };

  networking = {
    hostName = "maxTablet";
    networkmanager.enable = true;
  };

  specialisation = {
    /* wayland doesnt support touch keyboard
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
    */

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
