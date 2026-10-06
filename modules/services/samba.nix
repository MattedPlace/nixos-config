{
  flake.modules.nixos.base =
    { config, ... }:
    {
      services = {
        samba = {
          enable = false;
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
    };
}
