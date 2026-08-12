{ lib
, pkgs
, ...
}:

{
  networking = {
    useDHCP = lib.mkDefault true;
    enableIPv6 = false;
    networkmanager = {
      enable = true;
      plugins = with pkgs; [ networkmanager-openvpn ];
    };
  };
  systemd.services.NetworkManager-wait-online.enable = false;
}
