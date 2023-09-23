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

{ pkgs, lib, vars, ... }:

{
  imports = [ ./hardware-configuration.nix ] ++
            ( import ../../modules/desktops/virtualisation );

  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {                                  
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };    
      timeout = 5;                              # Auto select time
    };
  };

  environment = {                               # Packages installed system wide
    systemPackages = with pkgs; [               # This is because some options need to be configured.   
      discord
      x11vnc
      plex-media-player # Media Player
      simple-scan       # Scanning
    ];
  };

  nixpkgs.overlays = [                          # This overlay will pull the latest version of Discord
    (self: super: {
      discord = super.discord.overrideAttrs (
        _: { src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz";
          sha256 = "12yrhlbigpy44rl3icir3jj2p5fqq2ywgbp5v3m1hxxmbawsm6wi";
        };}
      );
    })
  ];
  
  hardware = {
    opengl = {
      enable = true;
      extraPackages = with pkgs; [
        libvdpau
        libGLU
      ];
      driSupport32Bit = true;
    };
    cpu.amd.updateMicrocode = true;
    sane = {                                    # Scanning
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };

  gnome.enable = true;

  networking = {
    hostName = "MaxwellDesktop";
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
