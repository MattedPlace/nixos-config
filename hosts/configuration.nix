#
#  Main system configuration. More information available in configuration.nix(5) man page.
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ default.nix
#   │   └─ configuration.nix *
#   └─ ./modules
#       ├─ ./desktops
#       │   └─ default.nix
#       ├─ ./editors
#       │   └─ default.nix
#       ├─ ./hardware
#       │   └─ default.nix
#       ├─ ./programs
#       │   └─ default.nix
#       ├─ ./services
#       │   └─ default.nix
#       ├─ ./shell
#       │   └─ default.nix
#       └─ ./theming
#           └─ default.nix
#

{ config, lib, pkgs, unstable, inputs, vars, ... }:

let
  terminal = pkgs.${vars.terminal};
in
{
  imports = ( import ../modules/desktops ++
              import ../modules/editors ++
              import ../modules/programs ++
              import ../modules/hardware ++
              import ../modules/services ++
              import ../modules/shell ++
              import ../modules/theming );

  boot = {
    tmp = {
      cleanOnBoot =  true;
      tmpfsSize = "5GB";
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  users = {
    groups = { uinput = {}; };          # needed for katana
    users.${vars.user} = {              # System User
      isNormalUser = true;
      extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" "lp" "scanner" "kvm" "libvirtd" "plex" "uinput" ];
    };

    users.${vars.user2} = {              # System User
      isNormalUser = true;
      extraGroups = [ "video" "audio" "camera" "networkmanager" "lp" "scanner" "kvm" "libvirtd" "plex" "uinput" ];
    };
  };

  time.timeZone = "America/Chicago";        # Time zone and internationalisation
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
    sudo.wheelNeedsPassword = false;
  };

  fonts.packages = with pkgs; [                # Fonts
    carlito                                 # NixOS
    vegur                                   # NixOS
    source-code-pro
    jetbrains-mono
    font-awesome                            # Icons
    corefonts                               # MS
    (nerdfonts.override {                   # Nerdfont Icons override
      fonts = [
        "FiraCode"
      ];
    })
  ];

  environment = {
    variables = {                           # Environment Variables
      TERMINAL = "${vars.terminal}";
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
    };
    systemPackages = with pkgs; [           # System-Wide Packages
      # Terminal
      terminal          # Terminal Emulator
      btop              # Resource Manager
      coreutils         # GNU Utilities
      git               # Version Control
      killall           # Process Killer
      lshw              # Hardware Config
      nano              # Text Editor
      nix-tree          # Browse Nix Store
      pciutils          # Manage PCI
      ranger            # File Manager
      smartmontools     # Disk Health
      tldr              # Helper
      usbutils          # Manage USB
      wget              # Retriever
      xdg-utils         # Environment integration

      # Video/Audio
      alsa-utils        # Audio Control
      feh               # Image Viewer
      image-roll        # Image Viewer
      linux-firmware    # Proprietary Hardware Blob
      mpv               # Media Player
      pavucontrol       # Audio Control
      pipewire          # Audio Server/Control
      pulseaudio        # Audio Server/Control
      qpwgraph          # Pipewire Graph Manager
      vlc               # Media Player
      ffmpeg            # Media convertor
      yt-dlp            # Youtube download
      audacity          # audio editor

      # Apps
      appimage-run      # Runs AppImages on NixOS
      firefox           # Browser
      microsoft-edge    # Browser
      google-chrome     # Browser
      brave             # Browser
      remmina           # XRDP & VNC Client
      networkmanagerapplet

      # File Management
      gnome.file-roller # Archive Manager
      pcmanfm           # File Browser
      p7zip             # Zip Encryption
      rsync             # Syncer - $ rsync -r dir1/ dir2/
      unzip             # Zip Files
      unrar             # Rar Files
      wpsoffice         # Office
      zip               # Zip

      #social media
      signal-desktop
      telegram-desktop


      # Other Packages Found @
      # - ./<host>/default.nix
      # - ../modules
    ] ++
    (with unstable; [
      # Apps
      # firefox           # Browser
    ]);
  };

  programs = {
    dconf.enable = true;
  };

  hardware.pulseaudio.enable = false;
  services = {
    printing = {                            # CUPS
      enable = true;
    };
    pipewire = {                            # Sound
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    openssh = {                             # SSH
      enable = true;
      allowSFTP = true;                     # SFTP
      extraConfig = ''
        HostKeyAlgorithms +ssh-rsa
      '';
    };
  };

  flatpak.enable = true;                    # Enable Flatpak (see module options)

  nix = {                                   # Nix Package Manager Settings
    settings ={
      auto-optimise-store = true;
    };
    gc = {                                  # Garbage Collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    package = pkgs.nixVersions.unstable;    # Enable Flakes
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true;        # Allow Proprietary Software.

  system = {                                # NixOS Settings
    #autoUpgrade = {                        # Allow Auto Update (not useful in flakes)
    #  enable = true;
    #  channel = "https://nixos.org/channels/nixos-unstable";
    #};
    stateVersion = "22.05";
  };

  home-manager.users.${vars.user} = {       # Home-Manager Settings
    home = {
      stateVersion = "22.05";
    };
    programs = {
      home-manager.enable = true;
    };
    xdg = {
      mime.enable = true;
      configFile."mimeapps.list".force = true;
      mimeApps = {
        enable = true;
        defaultApplications = {
          "image/jpeg" = ["image-roll.desktop" "feh.desktop"];
          "image/png" = ["image-roll.desktop" "feh.desktop"];
          "text/plain" = "nvim.desktop";
          "text/html" = "nvim.desktop";
          "text/csv" = "nvim.desktop";
          "application/pdf" = [ "wps-office-pdf.desktop" "firefox.desktop" "google-chrome.desktop"];
          "application/zip" = "org.gnome.FileRoller.desktop";
          "application/x-tar" = "org.gnome.FileRoller.desktop";
          "application/x-bzip2" = "org.gnome.FileRoller.desktop";
          "application/x-gzip" = "org.gnome.FileRoller.desktop";
          # "application/x-bittorrent" = "";
          "x-scheme-handler/http" = ["brave-browser.desktop" "google-chrome.desktop"];
          "x-scheme-handler/https" = ["brave-browser.desktop" "google-chrome.desktop"];
          "x-scheme-handler/about" = ["brave-browser.desktop" "google-chrome.desktop"];
          "x-scheme-handler/unknown" = ["brave-browser.desktop" "google-chrome.desktop"];
          "x-scheme-handler/mailto" = ["gmail.desktop"];
          "audio/mp3" = "mpv.desktop";
          "audio/x-matroska" = "mpv.desktop";
          "video/webm" = "mpv.desktop";
          "video/mp4" = "mpv.desktop";
          "video/x-matroska" = "mpv.desktop";
          "inode/directory" = "pcmanfm.desktop";
        };
      };
      desktopEntries.image-roll = {
        name = "image-roll";
        exec = "${pkgs.image-roll}/bin/image-roll %F";
        mimeType = ["image/*"];
      };
      desktopEntries.gmail = {
        name = "Gmail";
        exec = ''xdg-open "https://mail.google.com/mail/?view=cm&fs=1&to=%u"'';
        mimeType = ["x-scheme-handler/mailto"];
      };
    };
  };
}
