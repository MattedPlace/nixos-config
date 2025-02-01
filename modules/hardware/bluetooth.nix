#
#  Bluetooth
#

{ pkgs, host, ... }:

{


  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        AutoEnable = true;
        ControllerMode = "dual";
      };
    };
  };
  services = {
    blueman.enable = true;
    udev.extraRules = if host.hostName == "desktop" then ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0025", ATTR{authorized}="0"
    '' else '''';
  };
}
