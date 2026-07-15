let
  powerSettings = {
    services = {
      upower.enable = true;
      tlp.enable = false;
      auto-cpufreq.enable = true;
    };
  };
in
{
  flake.modules.nixos.power = {
    specialisation = {
      hyprland_.configuration = powerSettings;
      niri_.configuration = powerSettings;
    };
  };
}
