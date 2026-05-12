{
  flake.modules.nixos.games =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      vendorId = "2dc8";
      productId = "3109";
    in
    with lib;
    {
      users.groups.plugdev.members = [
        "root"
        "${config.host.user.name}"
      ];
      services.udev.extraRules = ''
        ACTION=="add", \
          ATTRS{idVendor}=="${vendorId}", \
          ATTRS{idProduct}=="${productId}", MODE="0666", \
          RUN+="${pkgs.kmod}/bin/modprobe xpad", \
          RUN+="${pkgs.bash}/bin/sh -c 'echo ${vendorId} ${productId} > /sys/bus/usb/drivers/xpad/new_id'"
      '';

      environment.systemPackages = [
        #pkgs.pkgsi686Linux.gperftools
        #pkgs.heroic # Game Launcher
        #pkgs.lutris # Game Launcher
        # pkgs.prismlauncher # MC Launcher
        # pkgs.retroarchFull # Emulator
        pkgs.steam # Game Launcher
        # pcsx2 # Emulator
      ];

      programs = {
        steam = {
          enable = true;
          # remotePlay.openFirewall = true;
          extraCompatPackages = with pkgs; [
            proton-ge-bin
          ];
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

    };
}
