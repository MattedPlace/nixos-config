#
# Gnome configuration
#

{ config, lib, pkgs, user, host, ... }:

let auto = with host; if hostName == "tablet" then true else false;
in
{
  config = lib.mkIf (config.specialisation != {}) {
    programs = {
      zsh.enable = true;
      dconf.enable = true;
      kdeconnect = {                                # For GSConnect
        enable = true;
        package = pkgs.gnomeExtensions.gsconnect;
      };
    };

    services = {
      xserver = {
        enable = true;
        libinput = {
          enable = true;
          touchpad = {
            tapping = true;
            scrollMethod = "twofinger";
            naturalScrolling = true;                # The correct way of scrolling
            accelProfile = "adaptive";              # Speed settings
            #accelSpeed = "-0.5";
            disableWhileTyping = true;
          };
        };
        layout = "us";             
        displayManager = {
          gdm = {
            enable = true;         
            autoLogin.delay = 5;
          };
          sessionCommands = "touchegg &";
          defaultSession = "gnome";
          autoLogin = {
            enable = auto;
            user = "max";
          };
        };
        desktopManager.gnome = {
          enable = true;
        };
      };
      touchegg.enable = true;
      udev.packages = with pkgs; [
        gnome.gnome-settings-daemon
      ];
    };

    hardware.pulseaudio.enable = false;

    environment = {
      systemPackages = with pkgs; [                 # Packages installed
        gnome.dconf-editor
        gnome.gnome-tweaks
        gnome.adwaita-icon-theme
      ];
      gnome.excludePackages = (with pkgs; [         # Gnome ignored packages
        gnome-tour
        gnome-photos
      ]) ++ (with pkgs.gnome; [
        baobab
        eog
        gnome-calculator
        gnome-calendar
        gnome-characters
        gnome-clocks
        gnome-contacts
        gnome-font-viewer
        gnome-logs
        gnome-maps
        gnome-music
        gnome-system-monitor
        gnome-weather
        pkgs.gnome-connections
        simple-scan
        totem
        yelp
        gedit
        epiphany
        geary
        tali
        iagno
        hitori
        atomix
        gnome-initial-setup
      ]);
    };
    home-manager.users.${user}.imports = [
      ./home.nix #window manager
    ];
  };
}

