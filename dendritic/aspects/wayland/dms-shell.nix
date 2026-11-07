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
          controlCenterWidgets = [
            {
              id = "brightnessSlider";
              width = 50;
            }
            {
              id = "volumeSlider";
              width = 50;
            }
            {
              id = "wifi";
              width = 50;
            }
            {
              id = "bluetooth";
              width = 50;
            }
            {
              id = "audioOutput";
              width = 50;
            }
            {
              id = "builtin_vpn";
              width = 50;
            }
            {
              id = "audioInput";
              width = 50;
            }
            {

              id = "plugin_dankKDEConnect";
              width = 50;
            }
            {
              id = "idleInhibitor";
              width = 50;
            }
            {
              id = "darkMode";
              width = 50;
            }
          ];
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
              transparency = 1;
              fontScale = 1.35;
              squareCorners = true;
              noBackground = false;
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

                { id = "systemTray"; }
                { id = "clipboard"; }
                { id = "cpuUsage"; }
                { id = "memUsage"; }
                {
                  id = "battery";
                  batteryStyle = "solid";
                }
                {
                  id = "controlCenterButton";
                  showAudioIcon = false;
                  showAudioPercent = false;
                  showBatteryIcon = false;
                  showBluetoothIcon = true;
                  showBrightnessIcon = false;
                  showBrightnessPercent = false;
                  showNetworkIcon = true;
                  showMicIcon = false;
                  showMicPercent = false;
                  showScreenSharingIcon = false;
                  showDoNotDisturbIcon = false;
                  showIdleInhibitorIcon = false;
                }

              ];
            }
          ];
          dynamicTheming = false;

        };

        session = {
          isLightMode = false;
        };
      };

      xdg.configFile."dms/settings.json".text = ''
        [
          {
            "enabled": true,
            "id": "user",
            "w": 5,
            "h": 1,
            "col": 0,
            "row": 0
          },
          {
            "enabled": true,
            "id": "settings",
            "w": 1,
            "h": 1,
            "col": 5,
            "row": 0
          },
          {
            "enabled": true,
            "id": "lock",
            "w": 1,
            "h": 1,
            "col": 6,
            "row": 0
          },
          {
            "enabled": true,
            "id": "power",
            "w": 1,
            "h": 1,
            "col": 7,
            "row": 0
          },
          {
            "enabled": true,
            "id": "brightnessSlider",
            "w": 4,
            "h": 1,
            "col": 4,
            "row": 1
          },
          {
            "enabled": true,
            "id": "volumeSlider",
            "w": 4,
            "h": 1,
            "col": 0,
            "row": 1
          },
          {
            "enabled": true,
            "id": "wifi",
            "w": 4,
            "h": 1,
            "col": 4,
            "row": 2
          },
          {
            "enabled": true,
            "id": "bluetooth",
            "w": 4,
            "h": 1,
            "col": 0,
            "row": 2
          },
          {
            "enabled": true,
            "id": "audioOutput",
            "w": 4,
            "h": 1,
            "col": 4,
            "row": 3
          },
          {
            "enabled": true,
            "id": "idleInhibitor",
            "w": 2,
            "h": 1,
            "col": 4,
            "row": 6
          },
          {
            "enabled": true,
            "id": "builtin_cups",
            "w": 2,
            "h": 1,
            "col": 6,
            "row": 6
          },
          {
            "enabled": true,
            "id": "battery",
            "w": 4,
            "h": 1,
            "col": 0,
            "row": 3
          },
          {
            "enabled": true,
            "id": "diskUsage",
            "w": 4,
            "h": 1,
            "col": 4,
            "row": 4
          },
          {
            "enabled": true,
            "id": "runningApps",
            "w": 4,
            "h": 1,
            "col": 0,
            "row": 5
          },
          { "enabled": true,
            "id": "edit",
            "w": 2,
            "h": 1,
            "col": 6,
            "row": 6
          },
          {
            "enabled": true,
            "id": "builtin_vpn",
            "w": 4,
            "h": 1,
            "col": 0,
            "row": 4
          },
          {
            "enabled": true,
            "id": "plugin_dankKDEConnect",
            "w": 4,
            "h": 1,
            "col": 4,
            "row": 5
          },
          {
            "id": "nightMode",
            "enabled": true,
            "w": 2,
            "h": 1,
            "col": 2,
            "row": 6
          }
        ]
      '';

    };
}
