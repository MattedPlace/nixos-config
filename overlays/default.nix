{ inputs }:
[
  (final: _prev: {
    customPkgs = import ../pkgs { pkgs = final; };
  })

  (final: _prev: {
    pnpm_10_34_0 = final.pnpm_10;
  })
  (import ./custom-packages.nix)
  (import ./custom-plex.nix)
  (import ./custom-xrizer.nix)
  (import ./opencomposite-priorites.nix)
]
