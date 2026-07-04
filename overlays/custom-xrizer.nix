_final: prev: {
  xrizer-custom = prev.xrizer.overrideAttrs (old: rec {
    version = "0.1.0";
    src = _final.fetchFromGitHub {
      owner = "RinLovesYou";
      repo = "xrizer";
      rev = "f491eddd0d9839d85dbb773f61bd1096d5b004ef";
      hash = "sha256-12M7rkTMbIwNY56Jc36nC08owVSPOr1eBu0xpJxikdw=";
    };
    cargoDeps = _final.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-87JcULH1tAA487VwKVBmXhYTXCdMoYM3gOQTkM53ehE=";
    };
    patches = [ ];
    doCheck = false;
  });
}
