{
  pkgs,
  lib,
  ...
}:
{
  # Enable System76 power daemon for intelligent power management
  hardware.system76.power-daemon.enable = true;

  # Thermal and power management services
  services = {
    # CPU temperature monitoring and management
    thermald.enable = true;

    # Battery status monitoring
    upower = {
      enable = true;
      # Enable percentage-based notifications
      percentageLow = 15;
      percentageCritical = 5;
      percentageAction = 3;
    };

    # Power profiles management
    power-profiles-daemon = {
      enable = false;
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

  # Disable USB autosuspend to prevent keyboard/mouse from turning off
  boot.kernelParams = [
    "mem_sleep_default=deep" # Prefer deep sleep modes
    "usbcore.autosuspend=-1" # Disable USB autosuspend globally
    # Note: nvme.noacpi=1 was removed in issue #464 — see boot.nix for
    # rationale. NVMe-related kernel params are now consolidated in boot.nix.
  ];

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
