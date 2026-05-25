{
  flake.modules.nixos.power = {
    services = {
      upower.enable = true;
      tlp.enable = false;
      auto-cpufreq.enable = true;
    };
  };
}
