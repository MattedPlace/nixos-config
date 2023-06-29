#
#  Home-manager configuration for desktop
#
#  flake.nix
#   └── ./hosts
#      └─ ./desktop
#          └─ ./home.nix
#

{ pkgs, ... }:

{
  home = {                                # Specific packages for desktop
    packages = with pkgs; [
      # Applications
      ansible           # Automation
      sshpass           # Ansible Dependency
      #handbrake         # Encoder
      hugo              # Static Website Builder
      mkvtoolnix        # Matroska Tools
      plex-media-player # Media Player
      signal-desktop    # social media 
      tdesktop          # social media
      streamlink        # streaming 
      streamlink-twitch-gui-bin
      piper             # Mouse configuration
      kdenlive          # Video Editor
      libreoffice       # Office Packages
      cura              # 3d printing slicer
      openscad          # CAD modeler 
      gdb               # debugger
      ghidra            # reverse engineering 

      # Imported in default or from modules
      #discord          # Comms           # See overlay default.nix
      #ffmpeg           # Video Support
      #gphoto2          # Digital Photography
      #steam            # Game Launcher

      # Packages I used in the past
      #darktable        # Raw Image Processing
      #gimp             # Graphical Editor
      #inkscape         # Vector Graphical Editor
      #kdenlive         # Video Editor
      #libreoffice      # Office Packages
      #shotcut          # Video Editor
    ];
  };

  services = {                            # Applets
    blueman-applet.enable = true;         # Bluetooth
  };
}
