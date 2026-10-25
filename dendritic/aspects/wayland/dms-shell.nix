{ inputs, config, ... }: {
  flake.modules.nixos.dms-shell = { config, ... }: {
    imports = [ inputs.dms-plugin-registry.nixosModules.default ];

    programs.dms-shell = {
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
}
