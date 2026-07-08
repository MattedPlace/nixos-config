_final: prev: {
  opencomposite-orion = {
    alyx = prev.opencomposite.overrideAttrs (rec {
      pname = "opencomposite-a";
      version = "1";
      src = prev.fetchFromGitLab {
        fetchSubmodules = true;
        owner = "OrionMoonclaw";
        repo = "OpenOVR";
        rev = "34311dabf430d6051d7e97f6081842a5394d2a67";
        hash = "sha256-sjgnai7RJemIXuviXhW6+L/zioz7UePaOUh3mVteGww=";
      };
      installPhase = ''
        runHook preInstall
        mkdir -p $out/lib/${pname}
        cp -r bin/ $out/lib/${pname}
        touch $out/lib/${pname}/bin/version.txt
        runHook postInstall
      '';
    });
    priorities = prev.opencomposite.overrideAttrs (rec {
      pname = "opencomposite-p";
      version = "1";
      src = prev.fetchFromGitLab {
        fetchSubmodules = true;
        owner = "OrionMoonclaw";
        repo = "OpenOVR";
        rev = "81d4363a6533276d4726f2191d7a30835faf60d1";
        hash = "sha256-Td18yRpwxnM9ir2fB2RRijsYdeSW48zXojNivAkgaeA=";
      };
      installPhase = ''
        runHook preInstall
        mkdir -p $out/lib/${pname}
        cp -r bin/ $out/lib/${pname}
        touch $out/lib/${pname}/bin/version.txt
        runHook postInstall
      '';
    });
  };
}
