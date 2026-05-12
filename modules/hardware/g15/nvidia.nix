{
  flake.modules.nixos.g15 =
    {
      config,
      lib,
      pkgs,
      vars,
      ...
    }:
    {
      boot = {
        blacklistedKernelModules = [ "nouveau" ];
      };
      services = {
        xserver.videoDrivers = [
          "amdgpu"
          "nvidia"
        ];
      };
      hardware = {
        graphics = {
          enable = true;
        };
        nvidia = {
          modesetting.enable = true;
          open = false;
          nvidiaSettings = true;
          package = config.boot.kernelPackages.nvidiaPackages.beta;
          prime = {
            offload = {
              enable = true;
              enableOffloadCmd = true;
            };
            # sync.enable = true;
            amdgpuBusId = "PCI:6:0:0";
            nvidiaBusId = "PCI:1:0:0";
          };
          powerManagement.enable = true;
        };
      };
    };
}
