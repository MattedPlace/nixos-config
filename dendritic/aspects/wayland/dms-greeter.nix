{
  flake.modules.nixos.dms-greeter = { config, ... }: {
    # Defaults to the uwsm-managed session over the plain "niri" entry.
    services.displayManager.defaultSession = "niri-uwsm";

    services.displayManager.dms-greeter = {
      enable = true;
      compositor = {
        name = "niri";
        customConfig = ''
          input {
              keyboard {
                  xkb {
                      layout "us"
                  }
              }
          }

          hotkey-overlay {
              skip-at-startup
          }
        '';
      };
      configHome = "/home/${config.host.user.name}";
      logs = {
        save = true;
        path = "/tmp/dms-greeter.log";
      };
    };

    environment.etc."dms-greeter/config.toml".text = ''
      default_user = "${config.host.user.name}"
    '';
  };
}
