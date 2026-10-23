{
  inputs,
  ...
}:

{
  flake.modules.nixos.flatpak =
    { pkgs, ... }:
    {
      imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
      environment = {
        systemPackages = with pkgs; [
          flatpak-xdg-utils
        ];
      };

      xdg.portal = {
        enable = true;
        config.common.default = [ "gtk" ];
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
          # xdg-desktop-portal-kde
          # xdg-desktop-portal-wlr
        ];
      };
      fonts.fontDir.enable = true; # Make sure these are in your system packages
      # (in configuration.nix or home.packages)
      services.flatpak = {
        enable = true;
        overrides = {
          global = {
            Context = {
              filesystems = [
                "/nix/store:ro"
                "xdg-config/fontconfig:ro"
              ];
              sockets = [
                "wayland"
                "x11"
                "fallback-x11"
              ];
            };
          };
        };
        packages = [
          "com.github.tchx84.Flatseal"
          #"io.github.tgeorgiadis.QuiverLauncher"
        ];
      };
    };
}
