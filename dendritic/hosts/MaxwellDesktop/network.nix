{
  flake.modules.nixos.desktop =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      networking = {
        useDHCP = lib.mkDefault true;
        hostName = "MaxwellDesktop";
        enableIPv6 = false;
        networkmanager = {
          enable = true;
          plugins = with pkgs; [ networkmanager-openvpn ];
        };
      };
      systemd.services.NetworkManager-wait-online.enable = false;
    };
}
