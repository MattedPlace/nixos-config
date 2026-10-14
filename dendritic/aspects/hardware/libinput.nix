{
  flake.modules.nixos.libinput = {
    nixpkgs.overlays = [ (import ../../../overlays/libinput { }) ];
    services.libinput = {
      enable = true;
    };
  };
}
