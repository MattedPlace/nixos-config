{
  flake.modules.nixos.packages =
    {
      inputs,
      ...
    }:
    {
      imports = [
        inputs.artcraft.nixosModules.default
      ];
      programs.artcraft = {
        enable = true;
        apps = [
          "pdfcraft"
        ]; # default: every app, newest version
        linkFonts = false; # if you manage /usr/share/fonts yourself
      };

    };
}
