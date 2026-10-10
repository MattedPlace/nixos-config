{
  flake.modules.nixos.packages =
    {
      pkgs,
      ...
    }:
    {
      environment = {
        systemPackages = with pkgs; [
          signal-desktop
        ];
      };
    };
}
