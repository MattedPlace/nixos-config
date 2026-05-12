#
#  Bluetooth
#
{
  flake.modules.nixos.desktop =
    { config, ... }:
    {
      hardware.bluetooth = {
        enable = true;
        settings = {
          General = {
            Enabl = "Source,Sink,Media,Socket";
            AutoEnable = true;
            ControllerMode = "dual";
          };
        };
      };

      services = {
        udev.extraRules = ''SUBSYSTEM=="usb", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0025", ATTR{authorized}="0" '';
      };
    };
}
