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
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
        nvidia-vaapi-driver
      ];
    };
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
