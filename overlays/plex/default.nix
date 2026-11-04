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
            sha256 = "04d302wy9qkmiaa4ki9qpb5l5gc36ij8hvnyf76ykq9rm187j722";
          }
        )
      )).computer.Linux.version;
    src = prev.fetchurl {
      url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
      sha256 = "sha256-dOmnHJfgbW6SXMQ5gnkUH9g47p30RvkOdpYU+iyHogY=";
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
