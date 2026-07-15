{
  flake.modules.nixos.g15 =
    {
      config,
      lib,
      pkgs,
      vars,
      ...
    }:
    let
      mkIfElse =
        p: yes: no:
        lib.mkMerge [
          (lib.mkIf p yes)
          (lib.mkIf (!p) no)
        ];
    in
    {
      #default case - make nvidia (gnome)
      config =
        mkIfElse (config.specialisation != { })
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
                enable32Bit = true;
              };
              nvidia = {
                modesetting.enable = true;
                open = true;
                nvidiaSettings = true;
                package = config.boot.kernelPackages.nvidiaPackages.production;
                prime = {
                  /*
                    offload = {
                      enable = true;
                      enableOffloadCmd = true;
                    };
                  */

                  sync.enable = true;
                  amdgpuBusId = "PCI:6:0:0";
                  nvidiaBusId = "PCI:1:0:0";
                };
                powerManagement.enable = true;
              };
            };
            environment.systemPackages = with pkgs; [
              nvtopPackages.nvidia # provide power usage graph
            ];
          }
          {
            # no nvidia for hyprland/niri
            boot.blacklistedKernelModules = [
              "nouveau"
              "nvidia"
            ];
            services.xserver.videoDrivers = [ "amdgpu" ];
          };
    };
}
