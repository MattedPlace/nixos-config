#
#  Bluetooth
#
{
  flake.modules.nixos.bluetooth =
    { config, ... }:
    {
      hardware.bluetooth = {
        enable = true;
        settings = {
          General = {
            Enable = "Source,Sink,Media,Socket";
            AutoEnable = false;
            ReconnectAttempts = 0;
            ControllerMode = "dual";
          };
        };
      };

      services = {
        udev.extraRules = ''SUBSYSTEM=="usb", ATTRS{idVendor}=="8087", ATTRS{idProduct}=="0025", ATTR{authorized}="0" '';
      };
    };
}
