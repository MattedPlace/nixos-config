{ withSystem, ... }:

{
  flake.modules.nixos.role-base =
    { config, ... }:
    {
      nixpkgs.pkgs = withSystem config.nixpkgs.hostPlatform.system ({ pkgs, ... }: pkgs);
      nixpkgs.hostPlatform = config.host.system;
    };

}
