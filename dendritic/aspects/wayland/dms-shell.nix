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
          #dankBatteryAlerts.enable = true;
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
          useFahrenheit = true;
          theme = "dark";
          barConfigs = [
            {
              id = "default";
              name = "Main Bar";
              enabled = true;

              position = 0;
              screenPreferences = [ "all" ];
              spacing = 0;
              innerPadding = -5;
              bottomGap = 0;
              transparency = 0;
              fontScale = 1.35;
              squareCorners = true;
              noBackground = true;
              maximizeWidgetIcons = true;
              maximizeWidgetText = false;
              borderEnabled = false;
              widgetOutlineEnabled = false;
              autoHide = false;
              scrollEnabled = false;
              leftWidgets = [
                { id = "launcherButton"; }
                { id = "workspaceSwitcher"; }
                { id = "focusedWindow"; }
              ];

              centerWidgets = [
                { id = "music"; }
                { id = "clock"; }
                { id = "weather"; }
              ];
              openOnOverview = true;

              rightWidgets = [

                { id = "dankKDEConnect"; }
                { id = "vpn"; }
                { id = "systemTray"; }
                { id = "clipboard"; }
                { id = "cpuUsage"; }
                { id = "memUsage"; }
                { id = "batteryPlus"; }
                { id = "controlCenterButton"; }

              ];
            }
          ];
          dynamicTheming = false;

        };

        session = {
          isLightMode = false;
        };
      };
    };
}
