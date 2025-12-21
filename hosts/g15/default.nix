#
#  Specific system configuration settings for laptop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./laptop
#   │        ├─ default.nix *
#   │        └─ hardware-configuration.nix
#   └─ ./modules
#       ├─ ./desktop
#       │   └─ ./bspwm/gnomeTablet/river/sway etc
#       │      └─ default.nix
#       └─ ./hardware
#           └─ default.nix
#

{ config, pkgs, user, lib, inputs, ... }:


{
  imports = [
    ./hardware-configuration.nix

  ] ++
  (import ../../modules/desktops/virtualisation);

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  gnome.enable = true;
  laptop.enable = true;
  #noNvidia.enable = true;
  nvidiaLaptop.enable = true;
  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };

  environment.systemPackages = with pkgs; [
    libimobiledevice
    ifuse # optional, to mount using 'ifuse'
    gimp3
  ];
  flatpak = {
    extraPackages = [
      "com.github.tchx84.Flatseal"
      "org.paraview.ParaView"
    ];
  };
  networking = {
    hostName = "MaxwellG15";
    networkmanager.enable = true;
  };
  services.logind.settings.Login.HandleLidSwitch = "ignore";
}
