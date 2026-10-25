{ config, ... }: {
  flake.modules.nixos.ytmusic = { config, ... }: {
  };

  flake.modules.homeManager.ytmusic = { pkgs, config, ... }: {
    home.packages = [ pkgs.ytmdesktop ];
  };
}
