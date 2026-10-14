{
  flake.modules.nixos.packages =
    {
      pkgs,
      ...
    }:
    {
      programs.appimage = {
        enable = true;
        binfmt = true;
        package = pkgs.appimage-run.override {
          extraPkgs =
            pkgs: with pkgs; [
              icu
              libxcrypt-legacy
              openssl
              zlib
            ];
        };
      };
    };
}
