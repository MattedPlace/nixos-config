{ config, ... }: {
  flake.modules.nixos.libvirtd = { ... }: {
    virtualisation.libvirtd.enable = true;
    users.users.${config.host.user.name}.extraGroups = [ "libvirtd" ];
  };
}
