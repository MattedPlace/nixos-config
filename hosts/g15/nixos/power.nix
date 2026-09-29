{
  pkgs,
  lib,
  ...
}:
{
  # Enable System76 power daemon for intelligent power management
  hardware.system76.power-daemon.enable = false;

  # Thermal and power management services
  services = {
    # CPU temperature monitoring and management
    thermald.enable = true;

    # Support for closing lid
    logind = {
      settings.Login = {
        HandleLidSwitch = lib.mkDefault "suspend";
        HandleLidSwitchExternalPower = "suspend";
      };
    };
    # Battery status monitoring
    upower = {
      enable = true;
      # Enable percentage-based notifications
      criticalPowerAction = "PowerOff";
      percentageLow = 15;
      percentageCritical = 10;
      percentageAction = 5;
    };

    # Power profiles management
    power-profiles-daemon = {
      enable = true;
      # Set default profile (options: power-saver, balanced, performance)
      # The following line is commented out as the default is 'balanced'
      # extraConfig.defaults.default-profile = "balanced";
    };

    # Advanced CPU frequency management (disabled but configured)
    auto-cpufreq = {
      enable = false;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "auto";
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

  # Power-related packages moved to main configuration.nix for consolidation

  # Kernel parameters for better power efficiency (removed - moved below)

  # Set CPU governor on boot
  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkForce "ondemand"; # Changed from "powersave" to prevent input device issues
    powertop.enable = lib.mkForce false; # Disabled - was causing USB device suspensions
  };

  # Fix systemd sleep targets
  systemd = {
    targets = {
      sleep.enable = true;
      suspend.enable = true;
      hibernate.enable = true;
      "hybrid-sleep".enable = true;
    };

  };
}
