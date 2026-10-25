{ config, ... }: {
  flake.modules.nixos.steam = { config, ... }: {
    programs.steam.enable = true;
    users.users.${config.host.user.name}.extraGroups = [ "steamcmd" ];

  };
}
