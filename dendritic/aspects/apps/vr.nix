{
  flake.modules.nixos.vr = {
    config,
    pkgs,
    ...
  }: {
    nixpkgs.overlays = [(import ../../../overlays/vr)];

    environment.systemPackages = with pkgs; [
      wayvr # Desktop VR
      android-tools # ADB for VR
      custom-xrizer
    ];

    services.wivrn = let
      inherit (pkgs) wivrn xrizer opencomposite;
    in {
      enable = true;
      openFirewall = true;

      # Run WiVRn as a systemd service on startup
      autoStart = true;

      # If you're running this with an nVidia GPU and want to use GPU Encoding (and don't otherwise have CUDA enabled system wide), you need to override the cudaSupport variable.
      package = wivrn.override {
        cudaSupport = true;
        #ovrCompatSearchPaths = "${xrizer}/lib/xrizer:${opencomposite}/lib/opencomposite:${pkgs.opencomposite-orion.priorities}/lib/opencomposite-p:${pkgs.opencomposite-orion.alyx}/lib/opencomposite-a";
        #ovrCompatSearchPaths = "${xrizer}/lib/xrizer:${opencomposite}/lib/opencomposite:${pkgs.custom-xrizer}/lib/xrizer:${pkgs.opencomposite-orion.priorities}/lib/opencomposite-p:${pkgs.opencomposite-orion.alyx}/lib/opencomposite-a";
        #ovrCompatSearchPaths = "${xrizer}/lib/xrizer:${opencomposite}/lib/opencomposite:${pkgs.custom-xrizer}/lib/xrizer";
      };

      # automatically imports pressure vessel xor runtimes
      steam = {
        enable = true;
        inherit (config.programs.steam) package;
        importOXRRuntimes = true;
      };

      highPriority = true;
    };
  };
}
