#
#  Gaming: Steam + MC + Emulation
#  Do not forget to enable Steam play for all title in the settings menu
#  When connecting a controller via bluetooth, it might error out. To fix this, remove device, pair - connect - trust, wait for auto disconnect, sudo rmmod btusb, sudo modprobe btusb, pair again.
#

{ config, pkgs, nur, lib, vars, ... }:

let
  vendorId = "2dc8";
  productId = "3109";
in
with lib;
{
  options = {
    games = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

  config = mkIf (config.games.enable) {
    users.groups.plugdev.members = [ "root" "${vars.user}" ];
    services.udev.extraRules = ''
      ACTION=="add", \
        ATTRS{idVendor}=="${vendorId}", \
        ATTRS{idProduct}=="${productId}", MODE="0666", \
        RUN+="${pkgs.kmod}/bin/modprobe xpad", \
        RUN+="${pkgs.bash}/bin/sh -c 'echo ${vendorId} ${productId} > /sys/bus/usb/drivers/xpad/new_id'"
    '';

    environment.systemPackages = [
      pkgs.pkgsi686Linux.gperftools
      pkgs.heroic # Game Launcher
      pkgs.lutris # Game Launcher
      # pkgs.prismlauncher # MC Launcher
      # pkgs.retroarchFull # Emulator
      pkgs.steam # Game Launcher
      # pcsx2 # Emulator
    ];

    programs = {
      steam = {
        enable = true;
        # remotePlay.openFirewall = true;
      };
      gamemode.enable = true;
      # Better Gaming Performance Steam: Right-click game - Properties - Launch options: gamemoderun %command%
      # Lutris: General Preferences - Enable Feral GameMode
      #                             - Global options - Add Environment Variables: LD_PRELOAD=/nix/store/*-gamemode-*-lib/lib/libgamemodeauto.so
    };

    hardware = {
      xpadneo.enable = true;
      # xpad-noone.enable = true;
      # xone.enable = true;
      steam-hardware.enable = true;
    };

    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-runtime"
    ];
  };
}
