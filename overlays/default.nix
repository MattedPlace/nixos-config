{ inputs }:
[
  (final: _prev: {
    customPkgs = import ../pkgs { pkgs = final; };
  })

  (import ./custom-packages.nix)
  (import ./custom-plex.nix)
  (import ./custom-xrizer.nix)
  (import ./opencomposite-priorites.nix)
]
