{ ... }: {
  flake.modules.nixos.boot = { ... }: {
    boot.loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
      timeout = 5; # Auto select time
    };
  };
}
