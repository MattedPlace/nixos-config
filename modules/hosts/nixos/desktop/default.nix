{
  config,
  inputs,
  ...
}:

let
  host = {
    name = "desktop";
    user.name = "Maxwell";
    state.version = "25.11";
    system = "x86_64-linux";
    monitors = [
      {
        name = "HDMI-A-1";
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
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    modules = with config.flake.modules.nixos; [
      base
      desktop

      nixvim
      gnome
      #   flatpak
      #   virtualisation
      games
    ];
  };

  flake.modules.nixos.desktop = {
    inherit host;
    home-manager.users.${host.user.name} = {
      imports = with config.flake.modules.homeManager; [
        mime

        #        claude
        kitty
        #       obs

        #      noctalia
      ];
    };
  };
}
