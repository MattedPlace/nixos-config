{ config, pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nouveau" ];
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };
}
