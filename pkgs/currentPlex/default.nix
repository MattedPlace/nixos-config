# customplex.nix
{
  pkgs,
}:

let
  # Override plexRaw to fetch the latest version from the Plex API
  plexRaw' = pkgs.plexRaw.overrideAttrs (old: rec {
    pname = "plexmediaserver";
    version =
      (builtins.fromJSON (
        builtins.readFile (
          builtins.fetchurl {
            url = "https://plex.tv/api/downloads/1.json";
            sha256 = "0x8bkl1cyi4xfvjhvv7mmrs5m4yyah7cg2hqml5ww02sp9101pcq";
          }
        )
      )).computer.Linux.version;
    src = pkgs.fetchurl {
      url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
      sha256 = "sha256-dgkj0Uny/d0DnExgYWjxfl2cFsiattlGzb7Guzmtro4=";
    };
    passthru = old.passthru // {
      inherit version;
    };
  });
in
pkgs.plex.override { plexRaw = plexRaw'; }
