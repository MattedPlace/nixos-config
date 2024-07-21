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
              ../../modules/programs/games.nix
            ] ++
            ( import ../../modules/desktops/virtualisation );

  boot = {                                      # Boot options
    kernelParams = [
      "processor.max_cstate=5"
      "rcu_nocbs=0-11"
    ];  # Set processor.max_cstate to 5 to prevent random crashes
    supportedFilesystems = [ "ntfs" ];
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
      haskellPackages.cabal-install
    ];
  };

  flatpak = {                                   # Flatpak Packages (see module options)
    extraPackages = [
      "com.ultimaker.cura"
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
    graphics = {
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
    networkmanager.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia"];
  hardware.nvidia = {
    # Modesetting is required by the wayland wm, but makes x11 wm laggy.
    modesetting.enable = config.wlwm.enable;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;
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
