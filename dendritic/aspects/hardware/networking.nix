{ ... }: {
  flake.modules.nixos.networking = { pkgs, ... }: {
    users.users.Maxwell.extraGroups = [ "networkmanager" ];

    networking = {
      dhcp = "internal";
      enableIPv6 = true;
      networkmanager = {
        enable = true;
        plugins = with pkgs; [ networkmanager-openvpn ];
      };
    };
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
