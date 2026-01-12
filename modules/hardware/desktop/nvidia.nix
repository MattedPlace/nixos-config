{ config, pkgs, ... }:
{
  boot = {
    kernelParams = [
      "nvidia_drm.fbdev=1"
    ]; # Set processor.max_cstate to 5 to prevent random crashes
    blacklistedKernelModules = [ "nouveau" ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
    };
  };
}
