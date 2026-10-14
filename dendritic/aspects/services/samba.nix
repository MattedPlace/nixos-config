{
  flake.modules.nixos.samba =
    { ... }:
    {
      services = {
        samba = {
          enable = true;
          settings = {
            # Set Password: $ smbpasswd -a <user>
            share = {
              "path" = "/home/Maxwell";
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
