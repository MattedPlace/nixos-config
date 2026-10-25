{ withSystem, config, ... }:

{
  flake.modules.nixos.role-base =
    { config, ... }:
    {
      nixpkgs.pkgs = withSystem config.nixpkgs.hostPlatform.system ({ pkgs, config, ... }: pkgs);
      nixpkgs.hostPlatform = config.host.system;
    };

}
