{  pkgs, vars, host, ... }:

with host;
{
  services = {
    ratbagd.enable = true;
    kanata =
      if hostName == "desktop" then {
        enable = true;
        keyboards.g4 = {
          config = ''
            (defsrc end)
            (deflayer default lalt)
          '';
          devices = [ "/dev/input/by-id/usb-Logitech_G502_HERO_Gaming_Mouse_067039603137-if01-event-kbd" ];
        };
      } else { };
  };
}
