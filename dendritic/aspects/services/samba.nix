{
  flake.modules.nixos.samba =
    { config, ... }:
    {
      services = {
        samba = {
          enable = true;
          nmbd.enable = false;
          settings = {
            # Set Password: $ smbpasswd -a <user>
            share = {
              "path" = "/home/${config.host.user.name}";
              "guest ok" = "yes";
              "read only" = "no";
            };
          };
          openFirewall = true;
        };
        samba-wsdd = {
          enable = true;
          openFirewall = true;
        };
      };
      systemd.services.samba-nmbd.enable = false;
    };
}
