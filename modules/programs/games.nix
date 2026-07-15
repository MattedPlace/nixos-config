{
  flake.modules.nixos.games =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    with lib;
    {

      config = lib.mkIf (config.specialisation != { }) {
        environment.systemPackages = [
          #pkgs.pkgsi686Linux.gperftools
          #pkgs.heroic # Game Launcher
          #pkgs.lutris # Game Launcher
          # pkgs.prismlauncher # MC Launcher
          # pkgs.retroarchFull # Emulator
          pkgs.steam # Game Launcher
          pkgs.protonplus
          # pcsx2 # Emulator
        ];

        programs = {
          steam = {
            enable = true;
            # remotePlay.openFirewall = true;
            extraCompatPackages = with pkgs; [

            ];
          };
          gamemode.enable = true;

          # Better Gaming Performance Steam: Right-click game - Properties - Launch options: gamemoderun %command%
          # Lutris: General Preferences - Enable Feral GameMode
          #                             - Global options - Add Environment Variables: LD_PRELOAD=/nix/store/*-gamemode-*-lib/lib/libgamemodeauto.so
        };
      };
    };
}
