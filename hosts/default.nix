#
#  These are the different profiles that can be used when building NixOS.
#
#  flake.nix 
#   └─ ./hosts  
#       ├─ default.nix *
#       ├─ configuration.nix
#       ├─ home.nix
#       └─ ./desktop OR ./laptop OR ./work OR ./vm
#            ├─ ./default.nix
#            └─ ./home.nix 
#
{ lib, inputs, nixpkgs, nixpkgs-unstable, home-manager, nur, hyprland, plasma-manager, vars, ... }:

let
  system = "x86_64-linux";                                  # System architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;                              # Allow proprietary software
  };

  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;                              # Allow proprietary software
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
      ./desktop
      ./configuration.nix

      home-manager.nixosModules.home-manager {              # Home-Manager module that is used.
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
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
      ./laptop
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
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
      ./vm
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
