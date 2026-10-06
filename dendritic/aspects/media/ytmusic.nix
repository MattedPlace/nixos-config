{...}: {
  flake.modules.nixos.ytmusic = {...}: {
    environment.persistence."/persist".users.Maxwell.directories = [".config/YouTube Music Desktop App"];
  };

  flake.modules.homeManager.ytmusic = {pkgs, ...}: {
    home.packages = [pkgs.ytmdesktop];
  };
}
