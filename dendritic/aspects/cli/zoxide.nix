{...}: {
  flake.modules.nixos.zoxide = {...}: {
    environment.persistence."/persist".users.Maxwell.directories = [".local/share/zoxide"];
  };

  flake.modules.homeManager.zoxide = {...}: {
    programs.zoxide = {
      enable = true;
      options = ["--cmd" "cd"];
    };
  };
}
