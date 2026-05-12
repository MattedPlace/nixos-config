#
#  Media Services: Plex, Torrenting and Automation
#
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      nixpkgs.overlays = [
        (final: prev: {
          customplex = prev.plex.override {
            plexRaw = prev.plexRaw.overrideAttrs (old: rec {
              pname = "plexmediaserver";
              version =
                (builtins.fromJSON (
                  builtins.readFile (
                    builtins.fetchurl {
                      url = "https://plex.tv/api/downloads/1.json";
                      sha256 = "1vjs46jmcf6v0hjzyl5qppzq0qj2pfi404h7j3n80nv9fsrc6ivf";
                    }
                  )
                )).computer.Linux.version;
              src = prev.fetchurl {
                url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
                sha256 = "sha256-pr1+VSObX0sBl/AddeG/+2dIbNdc+EtnvCzy4nTXVn8=";
              };
              passthru = old.passthru // {
                inherit version;
              };
            });
          };
        })
      ];
      services = {
        /*
          radarr = {
          enable = true;
          group = "plex";
          openFirewall = true;
          };
          sonarr = {
          enable = true;
          user = "root";
          group = "users";
          openFirewall = true;
          };
          bazarr = {
          enable = true;
          user = "root";
          group = "users";
          openFirewall = true;
          };
        */
        prowlarr = {
          enable = true;
          openFirewall = true;
        };
        flaresolverr = {
          enable = true;
          openFirewall = true;
        };
        deluge = {
          enable = true;
          web.enable = true;
          group = "plex";
          openFirewall = true;
          web.openFirewall = true;
        };
        plex = {
          package = pkgs.customplex;
          enable = true;
          openFirewall = true;
          user = "plex";
          group = "plex";
        };
      };
    };
}

# literally can't be bothered anymore with user permissions.
# So everything with root, add permissions 775 with group users in radarr and sonarr
# (Under Media Management - Show Advanced | Under Subtitles)
# Radarr & Sonarr: chmod 775
# Bazarr: chmod 664
# Prowlarr should just work
# Deluge:
#   Connection Manager: localhost:58846
#   Preferences: Change download folder and enable Plugins-label
