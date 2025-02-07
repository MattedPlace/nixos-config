#
#  Bluetooth
#

{ pkgs, host, config, ... }:

let isGnome = config.gnome.enable;
in
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

  services =
    {
      blueman.enable = if isGnome then false else true;
      udev.extraRules =
        if host.hostName == "desktop" then ''
          SUBSYSTEM=="usb", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0025", ATTR{authorized}="0"
        '' else '''';
    };
}
