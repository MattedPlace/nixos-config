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
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      inputs.home-manager.nixosModules.home-manager
      inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
      self.modules.nixos.role-laptop
      self.modules.nixos.g15
      self.modules.nixos.vr
      self.modules.nixos.plex
      self.modules.nixos.flatpak

      {
        # "disk" grants raw access to /dev/disk/by-partlabel/* block
        # devices, needed so QEMU (run as Maxwell, not root) can pass
        # crate-server-vm's cache/array partitions straight through --
        # see packages/deploy-test-vm.
        users.users.Maxwell.extraGroups = [
          "wheel"
          "docker"
          "input"
          "disk"
        ];

      }
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
