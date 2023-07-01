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

{ lib, inputs, nixpkgs, nixpkgs-unstable, home-manager, nur, user, location, hyprland, plasma-manager, ... }:

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
      inherit inputs unstable system user location hyprland;
      host = {
        hostName = "desktop";
        mainMonitor = "DVI-D-1";
        secondMonitor = "HDMI-A-2";
        mainMonitorX = "DVI-D-0"; #x11 server uses different names than wayland
        secondMonitorX = "HDMI-1";
      };
    };                                                      # Pass flake variable
    modules = [                                             # Modules that are used.
      nur.nixosModules.nur
      hyprland.nixosModules.default
      ./desktop
      ./configuration.nix

      home-manager.nixosModules.home-manager {              # Home-Manager module that is used.
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit unstable user;
          host = {
            hostName = "desktop"; 
            mainMonitor = "DVI-D-1";
            secondMonitor = "HDMI-A-2";
            mainMonitorX = "DVI-D-0";   #x11 server uses different names than wayland
            secondMonitorX = "HDMI-1";
          };
        };                                                  # Pass flake variable
        home-manager.users.${user} = {
          imports = [
            ./home.nix
            ./desktop/home.nix
            inputs.plasma-manager.homeManagerModules.plasma-manager
          ];
        };
      }
    ];
  };

  laptop = lib.nixosSystem {                                # Laptop profile
    inherit system;
    specialArgs = {
      inherit unstable inputs user location hyprland system;
      host = {
        hostName = "laptop";
        mainMonitor = "eDP-1";
        mainMonitorX = "eDP-1";
        secondMonitor = "HDMI-A-1";
        secondMonitorX = "HDMI-1";
      };
    };
    modules = [
      hyprland.nixosModules.default
      ./laptop
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit unstable user;
          host = {
            hostName = "laptop";
            mainMonitor = "eDP-1";
            mainMonitorX = "eDP-1";
            secondMonitor = "HDMI-A-1";
            secondMonitorX = "HDMI-1";
          };
        };
        home-manager.users.${user} = {
          imports = [
            ./home.nix
            ./laptop/home.nix
            inputs.plasma-manager.homeManagerModules.plasma-manager
          ];

        };
      }
    ];
  };

  tablet = lib.nixosSystem {                                # Laptop profile
    inherit system;
    specialArgs = {
      inherit unstable inputs user location;
      host = {
        hostName = "tablet";
        mainMonitorX = "eDP1";
        mainMonitor = "eDP-1";
      };
    };
    modules = [
      ./tablet
      ./configuration.nix
      hyprland.nixosModules.default

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit user;
          host = {
            hostName = "tablet";
            mainMonitorX = "eDP1";
            mainMonitor = "eDP-1";
          };
        };
        home-manager.users.${user} = {
          imports = [
            ./home.nix
            ./tablet/home.nix
            inputs.plasma-manager.homeManagerModules.plasma-manager
          ];
        };
      }
    ];
  };

  vm = lib.nixosSystem {                                    # VM profile
    inherit system;
    specialArgs = {
      inherit unstable inputs user location;
      host = {
        hostName = "vm";
        mainMonitor = "Virtual-1";
      };
    };
    modules = [
      ./vm
      ./configuration.nix

      home-manager.nixosModules.home-manager {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit unstable user;
          host = {
            hostName = "vm";
            mainMonitor = "Virtual-1";
          };
        };
        home-manager.users.${user} = {
          imports = [(import ./home.nix)] ++ [(import ./vm/home.nix)];
        };
      }
    ];
  };
}
