{...}: {
  flake.modules.nixos.libvirtd = {...}: {
    virtualisation.libvirtd.enable = true;
    users.users.Maxwell.extraGroups = ["libvirtd"];
  };
}
