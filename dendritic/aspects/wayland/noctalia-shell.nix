{ inputs, config, ... }: {
  flake.modules.nixos.noctalia-shell = { config, ... }: {
  };

  flake.modules.homeManager.noctalia-shell = { config, ... }: {
    imports = [ inputs.noctalia-shell.homeModules.default ];

    programs.noctalia = {
      enable = true;
      # Installed and configured, but not autostarted -- DMS is the
      # active shell for now. Flip to true to make Noctalia active again.
      systemd.enable = false;
    };
  };
}
