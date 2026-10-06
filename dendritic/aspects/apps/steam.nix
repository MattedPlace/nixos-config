{...}: {
  flake.modules.nixos.steam = {...}: {
    programs.steam.enable = true;
    users.users.Maxwell.extraGroups = ["steamcmd"];

    environment.persistence."/persist".users.Maxwell.directories = [
      ".steam"
      "games"
    ];
  };
}
