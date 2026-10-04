_final: prev: {
  custom-plex = prev.plex.overrideAttrs (old: rec {
    pname = "plexmediaserver";
    version =
      (builtins.fromJSON (
        builtins.readFile (
          builtins.fetchurl {
            url = "https://plex.tv/api/downloads/1.json";
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
}
