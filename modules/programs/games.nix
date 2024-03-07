#
# Gaming
# Steam + MC + Emulation
#
# Do not forget to enable Steam play for all title in the settings menu
#

{ config, pkgs, nur, lib, unstable, ... }:

{
  environment.systemPackages = [
    unstable.heroic                             # Game launchers
    unstable.lutris
    unstable.bottles
    unstable.prismlauncher
    pkgs.retroarchFull
    pkgs.wineWowPackages.stable
    pkgs.winetricks
    unstable.steam
  ];

  programs = {                                  # Needed to succesfully start Steam
    steam = {
      enable = true;
      #remotePlay.openFirewall = true;          # Ports for Stream Remote Play
    };
    gamemode.enable = true;                     # Better gaming performance
                                                # Steam: Right-click game - Properties - Launch options: gamemoderun %command%
                                                # Lutris: General Preferences - Enable Feral GameMode
                                                #                             - Global options - Add Environment Variables: LD_PRELOAD=/nix/store/*-gamemode-*-lib/lib/libgamemodeauto.so
  };

  services = {
    ratbagd.enable = true;
    kanata = {
      enable = true;
      keyboards.g4 = {
        config = ''
          (defsrc end)
          (deflayer default lalt)
        '';
        devices = [ "/dev/input/by-id/usb-Logitech_G502_HERO_Gaming_Mouse_067039603137-if01-event-kbd" ];
      };
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
  ];                                            # Use Steam for Linux libraries
}
