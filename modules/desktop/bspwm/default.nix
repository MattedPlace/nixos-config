#
#  Bspwm configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./bspwm
#               └─ default.nix *
#

{ config, lib, pkgs, host, ... }:

let
  monitor = with host;
    if hostName == "laptop" then
      "${pkgs.xorg.xrandr}/bin/xrandr --output ${secondMonitorX} --mode 1366x768 --pos 1920x0 --rotate normal --output ${mainMonitorX} --primary --mode 1920x1080 --pos 0x0 --rotate normal"
    else if hostName == "desktop" then
      "${pkgs.xorg.xrandr}/bin/xrandr --output ${secondMonitorX} --mode 1920x1080 --pos 0x0 --rotate normal --output ${mainMonitorX} --primary --mode 1920x1080 --rate 144 --pos 1920x0 --rotate normal"
    else if hostName == "tablet" then
      "${pkgs.xorg.xrandr}/bin/xrandr --output ${mainMonitorX} --primary --mode 1366x768 --pos 0x0 --rotate normal"
    else false;
  auto = with host;
    if hostName == "desktop" || hostName == "laptop" then
      false
    else true;
  touchpad = with host;
    if hostName == "laptop" || hostName == "tablet" then
      true
    else false;
in
{
  programs.dconf.enable = true;

  services = {
    touchegg.enable = touchpad;
    xserver = {
      enable = true;

      layout = "us";                              # Keyboard layout & €-sign
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

      displayManager = {                          # Display Manager
        lightdm = {
          enable = true;                          # Wallpaper and GTK theme
          background = pkgs.nixos-artwork.wallpapers.nineish-dark-gray.gnomeFilePath;
          greeters = {
            gtk = {
              theme = {
                name = "Dracula";
                package = pkgs.dracula-theme;
              };
              cursorTheme = {
                name = "Dracula-cursors";
                package = pkgs.dracula-theme;
                size = 16;
              };
            };
          };
        };
      autoLogin = {
          enable = auto;
          user = "max";
        };

        defaultSession = "none+bspwm";            # none+bspwm -> no real display manager
      };
      windowManager= {
        bspwm = {                                 # Window Manager
          enable = true;
        };
      };

      #Drivers for AMD GPU
      #videoDrivers = [                           # Video Settings
        #"amdgpu"
      #];

      displayManager.sessionCommands = monitor;

      serverFlagsSection = ''
        Option "BlankTime" "5"
        Option "StandbyTime" "0"
        Option "SuspendTime" "15"
        Option "OffTime" "0"
      '';                                         # sleep settings, in minutes
    };
  };

  programs.zsh.enable = true;                     # Weirdly needs to be added to have default user on lightdm

  environment.systemPackages = with pkgs; [       # Packages installed
    xclip
    xorg.xev
    xorg.xkill
    xorg.xrandr
    xterm
    #alacritty
    #sxhkd
  ];

  xdg.portal = {                                  # Required for flatpak with window managers
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
