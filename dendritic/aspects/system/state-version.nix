{
  flake.modules.nixos.role-base =
    { config, ... }:
    {
      system.stateVersion = config.host.state.version;
    };
}
