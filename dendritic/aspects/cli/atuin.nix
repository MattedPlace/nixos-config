{
  flake.modules.homeManager.atuin = { config, ... }: {
    programs.atuin = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
