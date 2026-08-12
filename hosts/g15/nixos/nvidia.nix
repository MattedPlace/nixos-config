{ config
, pkgs
, ...
}:
{
  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      nvidiaPersistenced = false;
      open = true; # NVIDIA 590+ requires open kernel modules for Turing GPUs (RTX 2070 Super)
      nvidiaSettings = true;
      # beta (595.45.04) fails to build against kernel 7.1 — it includes
      # linux/of_gpio.h, removed in 7.x. latest (610.43.02) handles the removal.
      package = config.boot.kernelPackages.nvidiaPackages.latest;

      prime = {
        sync.enable = true;
        offload.enable = false;
        amdgpuBusId = "PCI:6:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        # Vulkan support
        # vulkan-validation-layers dropped: debug-only layer, broken build on
        # nixpkgs 1.4.350.0 (update_deps.py git-clones in the sandbox).
        vulkan-loader
        vulkan-tools

        # Video acceleration
        libva-vdpau-driver
        nvidia-vaapi-driver

        # # CUDA support
        # cudaPackages.cudatoolkit
        # cudaPackages.cudnn
      ];
    };

  };

  environment = {
    systemPackages = with pkgs; [
      # nvidia-vaapi-driver
      libva
      libva-utils
      # nvtop
      # mesa-demos
      # clinfo
      # virtualglLib
      # vulkan-loader
      # vulkan-tools
    ];
  };
  # Kernel parameters for better NVIDIA performance and stability
  boot = {
    kernelParams = [
      "nvidia-drm.modeset=1" # Required for Wayland
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1" # Helps with suspend/resume
      "nvidia.NVreg_TemporaryFilePath=/tmp" # Fix for temp file issues
    ];

    # Early load NVIDIA modules
    kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_uvm"
      "nvidia_drm"
      "amdgpu"
    ];
    # Blacklist conflicting drivers
    blacklistedKernelModules = [ "nouveau" ];
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [
    "nvidia"
    "amdgpu"
  ];

}
