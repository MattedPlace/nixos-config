{ config, ... }: {
  flake.modules.nixos.brave = { config, ... }: {
  };
  flake.modules.homeManager.brave = { config, pkgs, ... }: {
    programs.brave = {
      enable = true;
      package = pkgs.master.brave-origin;
      commandLineArgs = [
        "--enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer,VaapiVideoDecoder,VaapiVideoEncoder,VaapiIgnoreDriverChecks"
        "--ozone-platform=wayland"
        "--enable-wayland-ime"
        "--enable-gpu-rasterization"
        "--enable-zero-copy"
        "--ignore-gpu-blocklist"
        "--enable-hardware-overlays"
        "--enable-accelerated-video-decode"
        "--enable-accelerated-video-encode"
        "--use-gl=egl"
        "--gtk-version=4"
      ];
      extensions = [
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      ];
    };
  };
}
