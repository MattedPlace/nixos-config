{
  inputs,
  config,
  self,
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
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      inputs.home-manager.nixosModules.home-manager
      self.modules.nixos.role-desktop
      self.modules.nixos.desktop
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
  flake.modules.nixos.desktop = {
    inherit host;
    home-manager.users.${host.user.name} = {
      imports = [
        config.flake.modules.homeManager.role-desktop
        {
          wayland.windowManager.niri.settings.output = [
            {
              _args = [ "HDMI-A-1" ];
              mode = "1920x1080@120";
              scale = 1.0;
            }
          ];
        }
      ];
    };
  };
}
