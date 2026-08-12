{ lib
, pkgs
, ...
}:
{
  # Consolidated services configuration
  services = {
    # Trackpad and input device optimization - using updated option names
    libinput = {
      enable = true; # Previously services.xserver.libinput.enable
      touchpad = {
        tapping = false;
        naturalScrolling = false;
        scrollMethod = "twofinger";
        disableWhileTyping = false;
        clickMethod = "clickfinger";
      };
    };

    # Backlight control key bindings
    actkbd = {
      enable = true;
      bindings = [
        # Add key bindings for brightness control
        {
          keys = [ 224 ];
          events = [ "key" ];
          command = "${pkgs.brightnessctl}/bin/brightnessctl set 5%-";
        }
        {
          keys = [ 225 ];
          events = [ "key" ];
          command = "${pkgs.brightnessctl}/bin/brightnessctl set 5%+";
        }
      ];
    };

    # Battery optimization
    upower = {
      enable = true;
      criticalPowerAction = "Hibernate";
    };

    # Support for closing lid
    logind = {
      settings.Login = {
        HandleLidSwitch = lib.mkDefault "suspend";
        HandleLidSwitchExternalPower = "ignore";
      };
    };
  };

  # Backlight control
  environment.systemPackages = [ pkgs.brightnessctl ];

  # Razer-specific utilities

  # Add Razer utilities
  # Razer hardware packages moved to main configuration.nix for consolidation
}
