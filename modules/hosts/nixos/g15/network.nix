{
  flake.modules.nixos.g15 =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      networking = {
        useDHCP = lib.mkDefault true;
        hostName = config.host.name;
        enableIPv6 = false;
        networkmanager = {
          enable = true;
          plugins = with pkgs; [ networkmanager-openvpn ];
        };
      };
      systemd.services.NetworkManager-wait-online.enable = false;
    };
}
