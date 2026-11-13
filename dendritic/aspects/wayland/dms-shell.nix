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
        acMonitorTimeout = 0;
        acLockTimeout = 600;
        acSuspendTimeout = 1200;
        acPostLockMonitorTimeout = 300;
        batteryMonitorTimeout = 0;
        batteryLockTimeout = 600;
        batterySuspendTimeout = 1200;
        batteryPostLockMonitorTimeout = 300;
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
              id = "builtin_cups";
              width = 50;
            }
            {
              id = "nightMode";
              width = 50;
            }
            {
              id = "settings";
              width = 50;
            }
            {
              id = "power";
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


    };
}
