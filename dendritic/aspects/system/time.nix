{ config, ... }: {
  flake.modules.nixos.time = { config, ... }: {
    time.timeZone = "America/Chicago";
  };
}
