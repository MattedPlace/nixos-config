#
#  These are the different profiles that can be used when building NixOS.
#
#  flake.nix
#   └─ ./hosts
#       ├─ default.nix *
#       ├─ configuration.nix
#       └─ ./<host>.nix
#           └─ default.nix
#

{ lib, inputs, nixpkgs, nixpkgs-unstable, home-manager, nur, nixvim, hyprland, vars, ... }:

let
  system = "x86_64-linux";                                  # System Architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;                              # Allow Proprietary Software
  };

  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  hmConfig = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.${vars.user}.imports = [
      nixvim.homeManagerModules.nixvim
    ];
  };


  lib = nixpkgs.lib;
in
{
   desktop = lib.nixosSystem {                               # Desktop profile
    inherit system;
    specialArgs = {
      inherit inputs unstable system vars hyprland;
      host = {
        hostName = "desktop";
        mainMonitor = "HDMI-A-2";
        mainMonitorX = "HDMI-1";
      };
    };                                                      # Pass flake variable
    modules = [                                             # Modules that are used.
      nur.nixosModules.nur
      nixvim.nixosModules.nixvim
      ./desktop
      ./configuration.nix
      home-manager.nixosModules.home-manager hmConfig
    ];
  };

  laptop = lib.nixosSystem {                                # Laptop profile
    inherit system;
    specialArgs = {
      inherit inputs unstable vars;
      host = {
        hostName = "laptop";
        mainMonitor = "eDP-1";
        mainMonitorX = "eDP-1";
        secondMonitor = "HDMI-A-1";
        secondMonitorX = "HDMI-1";
      };
    };
    modules = [
      nur.nixosModules.nur
      nixvim.nixosModules.nixvim
      ./laptop
      ./configuration.nix

      home-manager.nixosModules.home-manager hmConfig
    ];
  };

  vm = lib.nixosSystem {                                    # VM Profile
    inherit system;
    specialArgs = {
      inherit inputs unstable vars;
      host = {
        hostName = "vm";
        mainMonitor = "Virtual-1";
        secondMonitor = "";
      };
    };
    modules = [
      nixvim.nixosModules.nixvim
      ./vm
      ./configuration.nix

      home-manager.nixosModules.home-manager hmConfig
    ];
  };

}
