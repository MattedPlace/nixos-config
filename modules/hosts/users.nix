{
  flake.modules.nixos.base =
    { config, ... }:
    {
      users.users.${config.host.user.name} = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "power"
          "video"
          "audio"
          "camera"
          "networkmanager"
          "lp"
          "scanner"
        ];
      };
      security.sudo.wheelNeedsPassword = false;
    };

  flake.modules.darwin.base =
    { config, ... }:
    {
      users.users.${config.host.user.name} = {
        home = "/Users/${config.host.user.name}";
      };

      system.primaryUser = config.host.user.name;
    };
}
