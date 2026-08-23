# Workstation Host-Specific Packages
# Packages specifically for workstation hosts
# Compliant with NIXOS-ANTI-PATTERNS.md
{ pkgs, ... }: {
  # Workstation-specific packages (mix of headless and GUI)
  environment.systemPackages = with pkgs; [
    # Hardware-specific tools
    via
    wally-cli

    # Performance analysis
    perf-tools
    flamegraph

    # Advanced development
    gdb
    valgrind
    strace

    # Graphics and media development
    blender

    # Hardware monitoring
    gpu-viewer

    # Virtualization management
    virt-manager
  ];
}
