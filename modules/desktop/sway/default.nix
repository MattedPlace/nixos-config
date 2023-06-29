#
#  Sway configuration
#

{ config, lib, pkgs, host, ... }:

{
  imports = [ ../../programs/waybar.nix ];

  hardware.opengl.enable = true;
  hardware.nvidia.modesetting.enable = with host; if hostName == "desktop" then true else false;

  environment = {
    loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec sway --unsupported-gpu
      fi
    '';                                   # Will automatically open sway when logged into tty1
    variables = {
      #LIBCL_ALWAYS_SOFTWARE = "1";       # For applications in VM like alacritty to work
      #WLR_NO_HARDWARE_CURSORS = "1";     # For cursor in VM
    };
    sessionVariables = with host; if hostName == "desktop" then {
      GBM_BACKEND = "nvidia-drm";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      WLR_DRM_NO_ATOMIC = "1";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      _JAVA_AWT_WM_NONREPARENTING = "1";

      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";

      GDK_BACKEND = "wayland";
      WLR_NO_HARDWARE_CURSORS = "1";
      MOZ_ENABLE_WAYLAND = "1";
    } else {};
  };

  programs = {
    sway = {                              # Tiling Wayland compositor & window manager
      enable = true;
      extraPackages = with pkgs; [
        autotiling      # Tiling Script
        wev             # Input viewer
        wl-clipboard    # Commandline Clipboard #alternative clipman/wayclip
        wlr-randr
        xwayland
      ];
    };
  };

  xdg.portal = {                                  # Required for flatpak with window managers
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
