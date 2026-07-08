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
        pkgs.android-tools # ADB for VR
        pkgs.steam # Game Launcher
        pkgs.sidequest # Oculus tool
        pkgs.opencomposite-orion.alyx # compositor for VR
        pkgs.opencomposite-orion.priorities # compositor for VR
        pkgs.xrizer-custom # compositor for VR
        pkgs.protonplus
        # pcsx2 # Emulator
      ];

      programs = {
        steam = {
          enable = true;
          # remotePlay.openFirewall = true;
          extraCompatPackages = with pkgs; [
            #            proton-ge-bin
            proton-ge-rtsp-bin
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
      services.wivrn =
        let
          inherit (pkgs) wivrn xrizer opencomposite;
        in
        {
          enable = true;
          openFirewall = true;

          # Run WiVRn as a systemd service on startup
          autoStart = true;

          # If you're running this with an nVidia GPU and want to use GPU Encoding (and don't otherwise have CUDA enabled system wide), you need to override the cudaSupport variable.
          package = (
            wivrn.override ({
              cudaSupport = true;
              ovrCompatSearchPaths = "${xrizer}/lib/xrizer:${opencomposite}/lib/opencomposite:${pkgs.xrizer-custom}/lib/xrizer:${pkgs.opencomposite-orion.priorities}/lib/opencomposite-p:${pkgs.opencomposite-orion.alyx}/lib/opencomposite-a";
            })
          );

          # automatically imports pressure vessel xor runtimes
          steam = {
            enable = true;
            inherit (config.programs.steam) package;
            importOXRRuntimes = true;
          };

          highPriority = true;
        };

      hardware = {
        xpadneo.enable = true;
        # xpad-noone.enable = true;
        # xone.enable = true;
        steam-hardware.enable = true;
      };

    };
}
