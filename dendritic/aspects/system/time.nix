{ ... }: {
  flake.modules.nixos.time = { ... }: {
    time.timeZone = "America/Chicago";
  };
}
