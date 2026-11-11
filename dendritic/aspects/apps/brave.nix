{ config, ... }: {
  flake.modules.nixos.brave = { config, ... }: {
  };
  flake.modules.homeManager.brave = { config, pkgs, ... }: {
    programs.brave = {
      enable = true;
      package = pkgs.master.brave-origin;
      extensions = [
        # { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      ];
    };
  };
}
