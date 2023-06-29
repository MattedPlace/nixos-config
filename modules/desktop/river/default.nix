#
# River configuration
#

{ host, config, lib, pkgs, ... }:

{

  imports = [ ../../programs/waybar.nix ];

  hardware.opengl.enable = true;
  hardware.nvidia.modesetting.enable = with host; if hostName == "desktop" then true else false;

  environment = {
    loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        exec river
      fi
    '';                                   # Will automatically open River when logged into tty1
    
    sessionVariables = with host; if hostName == "desktop" then {
      GBM_BACKEND = "nvidia-drm";
      __GL_GSYNC_ALLOWED = "0";
      __GL_VRR_ALLOWED = "0";
      WLR_DRM_NO_ATOMIC = "1";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      _JAVA_AWT_WM_NONREPARENTING = "1";

      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      GDK_BACKEND = "wayland";
      WLR_NO_HARDWARE_CURSORS = "1";
      MOZ_ENABLE_WAYLAND = "1";
    } else {};

    systemPackages = with pkgs; [
      river
      wev
      wl-clipboard
      wlr-randr
      xdg-desktop-portal-wlr
      xwayland
    ];
  };

  programs.dconf.enable = true;

  xdg.portal = {                          # Required for flatpak with window managers
    enable = true;
    wlr.enable = true;                    # XDG for Wayland
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    #gtkUsePortal = true;
  };
}
