{
  inputs,
  ...
}:

{
  flake.modules.nixos.role-base =
    { config, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupCommand = "trash";
        extraSpecialArgs = {
          inherit (config) host;
          osConfig = config;
        };
        users.${config.host.user.name} = {
          home.stateVersion = config.host.state.version;

          programs = {
            home-manager.enable = true;
          };
        };
      };
    };

  flake.modules.homeManager.role-base =
    {
      config,
      pkgs,
      host,
      lib,
      ...
    }:
    {
      nix.package = lib.mkForce pkgs.nix;
      home = {
        username = "${host.user.name}";
        homeDirectory = "/home/${host.user.name}";
        packages = [ pkgs.home-manager ];
        stateVersion = host.state.version;
      };
    };
}
