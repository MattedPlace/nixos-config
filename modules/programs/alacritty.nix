#
#  Terminal Emulator
#

{ pkgs, vars, ... }:

{
  home-manager.users = builtins.listToAttrs (map (user: { name = user; value = { 
    programs = {
      alacritty = {
        enable = true;
        settings = {
          font = {
            normal.family = "FiraCode Nerd Font";
            bold = { style = "Bold"; };
            size = 11;
          };
          offset = {
            x = -1;
            y = 0;
          };
        };
      };
    };
  }; }) vars.userList);
}
