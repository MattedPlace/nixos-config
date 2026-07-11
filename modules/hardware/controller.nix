{
  flake.modules.nixos.controller =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      vendorId = "2dc8";
      productId = "3109";
    in
    {
      users.groups.plugdev.members = [
        "root"
        "${config.host.user.name}"
      ];
      #make controllers work
      services.udev.extraRules = ''
        ACTION=="add", \
          ATTRS{idVendor}=="${vendorId}", \
          ATTRS{idProduct}=="${productId}", MODE="0666", \
          RUN+="${pkgs.kmod}/bin/modprobe xpad", \
          RUN+="${pkgs.bash}/bin/sh -c 'echo ${vendorId} ${productId} > /sys/bus/usb/drivers/xpad/new_id'"
      '';

      hardware = {
        xpadneo.enable = true;
        # xpad-noone.enable = true;
        # xone.enable = true;
        steam-hardware.enable = true;
      };

    };
}
