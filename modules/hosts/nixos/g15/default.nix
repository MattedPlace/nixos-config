{
  config,
  inputs,
  ...
}:

let
  host = {
    name = "g15";
    user.name = "Maxwell";
    state.version = "22.05";
    system = "x86_64-linux";
    monitors = [
      {
        name = "eDP-1";
        w = "1920";
        h = "1080";
        refresh = "60";
        x = "0";
        y = "0";
      }
    ];
  };
in
{
  flake.nixosConfigurations.g15 = inputs.nixpkgs.lib.nixosSystem {
    modules = with config.flake.modules.nixos; [
      base
      g15

      games

      screen
      audio
      bluetooth
      power

      nixvim
      hyprland
      flatpak
      virtualisation
    ];
  };

  flake.modules.nixos.g15 = {
    inherit host;
    home-manager.users.${host.user.name} = {
      imports = with config.flake.modules.homeManager; [
        mime

        kitty

        noctalia
      ];
    };
  };
}
