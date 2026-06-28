{ pkgs, ... }: {
  # Define your custom packages here
  #plex-mcp-server = pkgs.callPackage ./plex-mcp-server { };

  # Note: gnome-ext-* packages are NOT registered here. They're exposed
  # at top-level pkgs.* via overlays/custom-packages.nix so that home
  # configs can reference them with `with pkgs;` (matching the rudra /
  # otp-keys / etc. pattern). Adding them here would expose them at
  # pkgs.customPkgs.gnome-ext-* which is a different namespace.
}
