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
            sha256 = "1f799wbsnkqiz9gjp15laha8qvywy2rpjq336nssw2dnvh1sl3dk";
          }
        )
      )).computer.Linux.version;
    src = prev.fetchurl {
      url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
      sha256 = "sha256-ieU0/7Vlrs2tsR1QhD2Cyk/pia4MfmAugx0Ec6Ook20=";
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
