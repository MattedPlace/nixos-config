{
  flake.modules.nixos.g15 =
    {
      pkgs,
      ...
    }:
    {
      environment = {
        systemPackages = with pkgs; [
        ];
      };
    };
}
