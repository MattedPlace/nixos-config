{
  flake.modules.nixos.g15 =
    { config, lib, ... }:
    {
      networking = {
        useDHCP = lib.mkDefault true;
        hostName = config.host.name;
        enableIPv6 = false;
        networkmanager.enable = true;
      };
      systemd.services.NetworkManager-wait-online.enable = false;
    };
}
