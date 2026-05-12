{
  flake.modules.nixos.desktop =
    { config, pkgs, ... }:
    {
      boot = {
        kernelParams = [
          "nvidia_drm.fbdev=1"
        ];
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
          package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
          open = false;
          nvidiaSettings = true;
        };
      };
    };
}
