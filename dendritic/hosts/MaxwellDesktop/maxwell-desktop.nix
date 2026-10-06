{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      inputs.determinate.nixosModules.default
      inputs.disko.nixosModules.disko
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

        networking = {
          hostName = "MaxwellDesktop";
          networkmanager.enable = true;
        };

        system.stateVersion = "24.05";

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit inputs; };

          users.Maxwell.imports = [
            self.modules.homeManager.role-desktop
            self.modules.homeManager.app-spawn-listener
            {
              wayland.windowManager.niri.settings.output = [
                {
                  _args = [ "HDMI-A-1" ];
                  mode = "1920x1080@60";
                  scale = 1.0;
                }
              ];
            }
          ];
        };
      }

    ];
  };
}
