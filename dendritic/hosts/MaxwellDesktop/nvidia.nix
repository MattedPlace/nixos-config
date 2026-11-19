{
  flake.modules.nixos.desktop =
    { pkgs, config, ... }:
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
          powerManagement.enable = true;
          powerManagement.finegrained = false; # only useful on Turing+ with PRIME
          package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
          open = false;
          nvidiaSettings = true;
        };
      };
    };
}
