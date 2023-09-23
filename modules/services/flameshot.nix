#
#  Screenshots
#

{ config, lib, pkgs, user, vars, ... }:

{
  config = lib.mkIf (config.services.xserver.enable) {
    home-manager.users = builtins.listToAttrs (map (user: { name = user; value = {  
      services.flameshot = {
        enable = true;
        settings = {
          General = {
            savePath = "/home/${user}/";
            saveAsFileExtension = ".png";
            uiColor = "#2d0096";
            showHelp = "false";
            disabledTrayIcon = "true";
          };
        };
      };
    }; }) vars.userList);
  };
}
