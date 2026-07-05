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
      #make controllers work
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
        pkgs.android-tools # ADB for VR
        pkgs.sidequest # Oculus tool
        pkgs.opencomposite-priorities # compositor for VR
        pkgs.xrizer-custom # compositor for VR
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
        /*
          alvr = {
            enable = true;
            openFirewall = true;
          };
        */

        # Better Gaming Performance Steam: Right-click game - Properties - Launch options: gamemoderun %command%
        # Lutris: General Preferences - Enable Feral GameMode
        #                             - Global options - Add Environment Variables: LD_PRELOAD=/nix/store/*-gamemode-*-lib/lib/libgamemodeauto.so
      };
      services.wivrn = {
        enable = true;
        openFirewall = true;

        # Run WiVRn as a systemd service on startup
        autoStart = true;

        # If you're running this with an nVidia GPU and want to use GPU Encoding (and don't otherwise have CUDA enabled system wide), you need to override the cudaSupport variable.
        package = (pkgs.wivrn.override { cudaSupport = true; });

        # You should use the default configuration (which is no configuration), as that works the best out of the box.
        # However, if you need to configure something see https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md for configuration options and https://mynixos.com/nixpkgs/option/services.wivrn.config.json for an example configuration.
      };

      hardware = {
        xpadneo.enable = true;
        # xpad-noone.enable = true;
        # xone.enable = true;
        steam-hardware.enable = true;
      };

    };
}
