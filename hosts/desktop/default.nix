#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./desktop
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       ├─ ./desktop
#       │   ├─ ./hyprland/ || gnome || sway || bspwm || kde
#       │   │   └─ default.nix
#       │   └─ ./virtualisation
#       │       └─ default.nix
#       ├─ ./programs
#       │   └─ games.nix
#       └─ ./hardware
#           └─ default.nix
#

{ pkgs, lib, vars, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ] ++
  (import ../../modules/hardware/desktop) ++
  (import ../../modules/desktops/virtualisation);

  boot = {
    # Boot options
    blacklistedKernelModules = [ "iwlwifi" ];
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

  environment = {
    systemPackages = with pkgs; [
      libreoffice # office
      go2tv # Casting
      #google-cloud-sdk-gce # Google Cloud
    ];
  };

  hardware = {
    sane = {
      # Scanning
      enable = true;
      brscan5 = {
        enable = true;
        netDevices = {
          brother = { model = "HL-2280DW"; ip = "10.0.0.163"; };
        };
      };
    };
  };

  gnome.enable = true;

  networking = {
    hostName = "MaxwellDesktop";
    networkmanager.enable = true;
  };




  /*
    services = {
    blueman.enable = true;                      # Bluetooth
    xserver.videoDrivers = [ "nvidia" ];
    samba = {                                   # File Sharing over local network
      enable = true;                            # Don't forget to set a password:  $ smbpasswd -a <user>
      shares = {
        share = {
          "path" = "/home/${user}";
          "guest ok" = "yes";
          "read only" = "no";
        };
      };
      openFirewall = true;
    };
    };
  */
}
