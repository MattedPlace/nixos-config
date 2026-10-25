{ inputs, config, ... }: {
  flake.modules.nixos.zen = { config, ... }: {
  };

  flake.modules.homeManager.zen = { config, ... }: {
    imports = [ inputs.zen-browser.homeModules.default ];

    programs.zen-browser = {
      enable = true;
      profiles.${config.host.user.name} = {
        isDefault = true;
        path = "deuteqrr.Default Profile";
        settings = { };
      };
    };
  };
}
