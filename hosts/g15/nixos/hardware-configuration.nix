{ config
, lib
, modulesPath
, pkgs
, ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
