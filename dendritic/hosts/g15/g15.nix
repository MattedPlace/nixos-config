{
  inputs,
  config,
  self,
  ...
}:
let
  host = {
    name = "g15";
    user.name = "Maxwell";
    state.version = "22.05";
    system = "x86_64-linux";
  };
in
{
  flake.nixosConfigurations.g15 = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [
      inputs.home-manager.nixosModules.home-manager
      inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
      self.modules.nixos.role-laptop
      self.modules.nixos.g15
      self.modules.nixos.vr
      self.modules.nixos.plex
      self.modules.nixos.flatpak
    ];
  };
  flake.modules.nixos.g15 = {
    inherit host;
    home-manager.users.${host.user.name} = {
      imports = with config.flake.modules.homeManager; [
        role-laptop
        {
          wayland.windowManager.niri.settings.output = [
            {
              _args = [ "eDP-1" ];
              mode = "1920x1080@60";
              scale = 1.0;
            }
          ];
        }
      ];
    };
  };
}
