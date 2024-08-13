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
  (import ../../modules/desktops/virtualisation);

  boot = {                                      # Boot options
    kernelParams = [
      "processor.max_cstate=5"
      "rcu_nocbs=0-11"
      #  "nvidia_drm.fbdev=1"
    ];  # Set processor.max_cstate to 5 to prevent random crashes
    #blacklistedKernelModules = [ "nouveau" ];
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
      timeout = 5;                              # Auto select time
    };
  };

  environment = {
    systemPackages = with pkgs; [
      libreoffice # office
      discord # Messaging
      gimp # Image Editor
      go2tv # Casting
      #google-cloud-sdk-gce # Google Cloud
      jellyfin-media-player # Media Player
      kodi # Media Player
      moonlight-qt # Remote Streaming
      obs-studio # Live Streaming
      plex-media-player # Media Player
      rclone # Gdrive ($ rclone config | rclone mount --daemon gdrive:<path> <host/path>)
    ];
  };

  flatpak = {
    extraPackages = [
      "com.github.tchx84.Flatseal"
      "com.ultimaker.cura"
      "com.stremio.Stremio"
    ];
  };

  nixpkgs.overlays = [                          # This overlay will pull the latest version of Discord
    (self: super: {
      discord = super.discord.overrideAttrs (
        _: { src = builtins.fetchTarball {
          url = "https://discord.com/api/download?platform=linux&format=tar.gz";
          sha256 = "1mmyxjvwfp8fx89wb02k0rn24pnp2ifj5q4m38m9z919yphahafi";
        };}
      );
    })
  ];

  services.xserver.videoDrivers = [ "nouveau"];
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        # intel-media-driver
        # intel-vaapi-driver
        #       nvidia-vaapi-driver
      ];
    };
    /*
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
    */

    sane = {                                    # Scanning
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
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
