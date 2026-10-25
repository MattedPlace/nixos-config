{ config, ... }: {
  flake.modules.nixos.zoxide = { config, ... }: {
  };

  flake.modules.homeManager.zoxide = { config, ... }: {
    programs.zoxide = {
      enable = true;
      options = [
        "--cmd"
        "cd"
      ];
    };
  };
}
