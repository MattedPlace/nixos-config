{
  flake.modules.nixos.desktop =
    { config, pkgs, ... }:
    {
      environment = {
        systemPackages = with pkgs; [
        ];
      };
    };
}
