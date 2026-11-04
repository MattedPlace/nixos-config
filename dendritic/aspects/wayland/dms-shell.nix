{ inputs, ... }: {
  flake.modules.nixos.dms-shell =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.dms-plugin-registry.nixosModules.default ];

      programs.dux-shell = {
        enable = true;
        plugins = {
          #        dankBatteryAlerts.enable = true;
          dankClight.enable = true;
          webSearch.enable = true;
          dankLauncherKeys.enable = true;
          dankKDEConnect.enable = true;
          nixMonitor.enable = true;
        };
      };
      programs = {
        kdeconnect.enable = true;
      };

    };
  flake.modules.homeManager.dms-shell =
    {
      config,
      # lib,
      ...
    }:
    {
      imports = [
        inputs.dms.homeModules.dank-material-shell
      ];

      stylix.targets.dank-material-shell.enable = true;

      programs.dank-material-shell = {
        enable = true;

        settings = {
          theme = "dark";
          dynamicTheming = false;
        };

        session = {
          isLightMode = false;
        };
      };
    };
}
