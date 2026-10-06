{ ... }: {
  flake.modules.nixos.zoxide = { ... }: {
  };

  flake.modules.homeManager.zoxide = { ... }: {
    programs.zoxide = {
      enable = true;
      options = [
        "--cmd"
        "cd"
      ];
    };
  };
}
