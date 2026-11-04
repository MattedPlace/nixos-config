{ config, ... }: {
  flake.modules.nixos.power = { config, ... }: {
    boot.kernelParams = [ "usbcore.autosuspend=-1" ];
    services = {
      power-profiles-daemon.enable = false;
      thermald.enable = false;
      tlp.enable = false;
      upower = {
        enable = true;
        # Enable percentage-based notifications
        percentageLow = 15;
        percentageCritical = 5;
        percentageAction = 3;
        criticalPowerAction = "Hibernate";
      };

      auto-cpufreq = {
        enable = true;
        settings = {
          battery = {
            governor = "powersave";
            turbo = "never";
            energy_performance_preference = "power";
            cpu_energy_performance_policy = "power";
          };
          charger = {
            governor = "performance";
            turbo = "auto";
            energy_performance_preference = "performance";
            cpu_energy_performance_policy = "performance";
          };
        };
      };
    };
  };
}
