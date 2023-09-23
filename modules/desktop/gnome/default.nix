#
# Gnome configuration
#

{ config, lib, pkgs, user, ... }:

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
        layout = "us";             
        libinput.enable = true;
        displayManager = {
          gdm.enable = true; #display manager
        };
        desktopManager.gnome.enable = true;
      };
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
        xclip                          
      ];
      gnome.excludePackages = (with pkgs; [         # Gnome ignored packages
        gnome-tour
      ]) ++ (with pkgs.gnome; [
        cheese
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
