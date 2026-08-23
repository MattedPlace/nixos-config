# Virtualization Packages
# Container and VM management tools
# Compliant with NIXOS-ANTI-PATTERNS.md
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.packages.virtualization;
  # Import existing virtualization package sets
  packageSets = import ../../packages/sets.nix { inherit pkgs lib; };
in
{
  options.packages.virtualization = {
    enable = lib.mkEnableOption "Virtualization packages";

    docker = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Docker tools (headless-compatible)";
    };

    vm = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable VM management tools";
    };

    kubernetes = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Kubernetes tools (headless-compatible)";
    };
  };

}
