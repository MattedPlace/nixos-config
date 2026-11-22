{
  flake.modules.nixos.packages =
    {
      pkgs,
      inputs,
      ...
    }:
    {
      environment = {
        systemPackages = with pkgs; [
        google-chrome
          signal-desktop
          nautilus
          tuxtype
          inputs.yt-x.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      };
    };
}
