_final: prev: {
  xrizer-custom = prev.xrizer.overrideAttrs (rec {
    version = "1";
    pname = "xrizer-custom";
    src = _final.fetchFromGitHub {
      owner = "Mr-Zero88";
      repo = "xrizer";
      rev = "1a7615eedaf4f889b5fc8ad078488197170e4de1";
      hash = "sha256-Rb1pssAq6Zx6VmQVQtGcThkA6zCwi5X7G7aHmdsDrJo=";
    };
    patches = [ ];
    doCheck = false;
  });
}
