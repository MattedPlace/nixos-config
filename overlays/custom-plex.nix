_final: prev:
let
  # 1. Build a custom plexRaw derivation with the latest version
  custom-plexRaw = prev.plexRaw.overrideAttrs (old: rec {
    pname = "plexmediaserver";
    version =
      (builtins.fromJSON (
        builtins.readFile (
          builtins.fetchurl {
            url = "https://plex.tv/api/downloads/1.json";
            #sha256 = "sha256-ieU0/7Vlrs2tsR1QhD2Cyk/pia4MfmAugx0Ec6Ook20=";
            sha256 = "0lwj5bjkbmj6h39x2xagksa36iyqaff08gxrfdipsh4vx6040zgb";
          }
        )
      )).computer.Linux.version;
    src = prev.fetchurl {
      url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
      sha256 = "sha256-qgnyZt3PQI4Qz3ulYbbkVObhCbqUFjlraWW9THnzcUk=";
    };
    passthru = old.passthru // {
      inherit version;
    };
  });

in
{
  # 2. Override the FHS wrapper (the 'plex' package) to use our custom raw package
  custom-plex = prev.plex.override {
    plexRaw = custom-plexRaw;
  };
}
