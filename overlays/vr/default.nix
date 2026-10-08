{ ... }: _final: prev: {
  custom-xrizer = prev.xrizer.overrideAttrs (rec {
    version = "hla";
    src = prev.fetchFromGitHub {
      owner = "Mr-Zero88";
      repo = "xrizer";
      rev = "512a7ae6e05eba3e8d5e6f1a20ee9632a528bd0f";
      hash = "sha256-3bp1JYNPUbNwBkjZG2Ex1jtj3L8Vt78wFKhHAPpTD58=";
    };
    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-F6ZTOCPih04tT0hlaso43/TNP5bahQkF8HOdjn7/bBc=";
    };
    patches = [ ];
    # The original postPatch looks for features = ["static"], which no longer exists.
    postPatch = ''
      substituteInPlace src/graphics_backends/gl.rs \
        --replace-fail 'libGLX.so.0' '${prev.lib.getLib prev.libGL}/lib/libGLX.so.0'
    '';
    # Or, if the gl.rs line also no longer matches:
    # postPatch = "";   doCheck = false;
  });
}
