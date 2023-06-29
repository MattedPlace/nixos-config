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

{ pkgs, lib, user, config, ... }:

{
  imports =                                               # For now, if applying to other system, swap files
    [(import ./hardware-configuration.nix)] ++            # Current system hardware config @ /etc/nixos/hardware-configuration.nix
    [(import ../../modules/programs/games.nix)] ++        # Gaming
    [(import ../../modules/desktop/gnome/default.nix)] ++ 
    (import ../../modules/desktop/virtualisation);       # Virtual Machines & VNC

  boot = {                                      # Boot options
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {                                  # For legacy boot:
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };    
      timeout = 5;                              # Grub auto select time
    };
  };

  environment = {                               # Packages installed system wide
    systemPackages = with pkgs; [               # This is because some options need to be configured.   
      discord
      x11vnc
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
  };

  networking = {
    hostName = "maxDesktop";
  };

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

  specialisation = {
    hyprland.configuration = {
      imports = [(import ../../modules/desktop/hyprland/default.nix)];
      home-manager.users.${user}.imports = [
        ../../modules/desktop/hyprland/home.nix #window manager
      ];
    };
    sway.configuration = {
      imports = [(import ../../modules/desktop/sway/default.nix)];
      home-manager.users.${user}.imports = [
        ../../modules/desktop/sway/home.nix #window manager
      ];
    };
    /* river is very slow to start and cannot get monitors right
    river.configuration = {
      imports = [(import ../../modules/desktop/river/default.nix)];
      home-manager.users.${user}.imports = [
        ../../modules/desktop/river/home.nix #window manager
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
