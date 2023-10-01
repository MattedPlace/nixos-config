#
#  Network Shares
#

{ vars, ... }:

{
  services = {
    samba = {
      enable = true;
      shares = {                                # Set Password: $ smbpasswd -a <user>
        share = {
          "path" = "/home/${builtins.elemAt vars.userList 0}";
          "guest ok" = "yes";
          "read only" = "no";
        };
      };
      openFirewall = true;
    };
  };
}
