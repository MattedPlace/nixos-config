{ config, lib, pkgs, vars, ... }:
with lib;
{
  options = {
    nvidiaLaptop = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = mkIf (config.nvidiaLaptop.enable)
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
