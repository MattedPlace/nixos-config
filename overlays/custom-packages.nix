final: _prev: {
  # gnome-ext-forge — pinned to master commit (see pkgs/gnome-ext-forge
  # for rationale). Source-of-truth for UUID + version is the metadata.json
  # baked into the upstream commit we pin.
  gnome-ext-forge = final.callPackage ../pkgs/gnome-ext-forge { };
  currentPlex = final.callPackage ../pkgs/currentPlex { };
}
