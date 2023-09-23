#
#  Mounting tool
#

{ config, lib, pkgs, vars, ... }:

{
  home-manager.users = builtins.listToAttrs (map (user: { name = user; value = {
    services = {
      udiskie = {
        enable = true;
        automount = true;
        tray = "auto";
      };
    };
  }; }) vars.userList);
}
