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
            sha256 = "1084jhyrixaghblzplmf7kl9yqbfvmjb1m249hvmbhpsrms0j2fg";
          }
        )
      )).computer.Linux.version;
    src = prev.fetchurl {
      url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
      sha256 = "sha256-b2ocgzbXeeHyAVGmk0NJiEutb2pmsYorGJuW5Vw7Pts=";
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
