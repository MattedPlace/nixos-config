{   config, lib, pkgs, host, ... }:

with host;
{
  # Enable the uinput module
  boot.kernelModules = [ "uinput" ];

  # Enable uinput
  hardware.uinput.enable = true;

  # Set up udev rules for uinput
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  # Ensure the uinput group exists
  users.groups.uinput = { };

  # Add the Kanata service user to necessary groups
  systemd.services.kanata-internalKeyboard.serviceConfig = {
    SupplementaryGroups = [
      "input"
      "uinput"
    ];
  };

  services = {
    ratbagd.enable = true;
    kanata =
      if hostName == "desktop" then {
        enable = true;
        keyboards.internalKeyboard = {
          config = ''
            (defsrc end)
            (deflayer default lalt)
          '';
          devices = [ "/dev/input/by-id/usb-Logitech_G502_HERO_Gaming_Mouse_067039603137-if01-event-kbd" ];
        };
      } else { };
  };
}
