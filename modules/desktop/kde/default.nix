#
# KDE Plasma 5 configuration
#

{ host, config, lib, pkgs, ... }:

let auto = with host; if hostName == "tablet" then true else false;
in
{
  programs = {
    zsh.enable = true;
    dconf.enable = true;
    kdeconnect = {                                # For GSConnect
      enable = true;
      package = pkgs.plasma5Packages.kdeconnect-kde;
    };
  };

  services = {
    xserver = {
      enable = true;
      layout = "us";                              # Keyboard layout 

      displayManager = {
        sddm.enable = true;          # Display Manager
        defaultSession = "plasma";
        autoLogin = {
          enable = auto;
          user = "max";
        };
        sessionCommands = "touchegg &";
      };
      desktopManager.plasma5 = {
        enable = true;                            # Desktop Manager
      };
    };
    touchegg.enable = true;
  };

  environment = {
    systemPackages = with pkgs.libsForQt5; [                 # Packages installed
      packagekit-qt
      bismuth
    ];
    plasma5.excludePackages = with pkgs.libsForQt5; [
      elisa
      khelpcenter
      konsole
      oxygen
    ];
  };
}
