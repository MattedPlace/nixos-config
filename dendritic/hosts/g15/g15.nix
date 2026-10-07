{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.g15 = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit inputs;};
    modules = [
      inputs.home-manager.nixosModules.home-manager
      inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
      self.modules.nixos.role-laptop
      self.modules.nixos.g15
      self.modules.nixos.vr

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
          hostName = "g15";
          networkmanager.enable = true;
        };

        system.stateVersion = "24.05";

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit inputs;};

          users.Maxwell.imports = [
            self.modules.homeManager.role-laptop
            {
              wayland.windowManager.niri.settings.output = [
                {
                  _args = ["eDP-1"];
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
