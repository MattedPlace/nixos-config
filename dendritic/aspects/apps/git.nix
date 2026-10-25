{ config, ... }: {
  flake.modules.nixos.git = { pkgs, config, ... }: {
    environment.systemPackages = [ pkgs.git-crypt ];
  };

  flake.modules.homeManager.git = { pkgs, config, ... }: {
    home.packages = [ pkgs.lazygit ];

    programs.git = {
      enable = true;
      settings = {
        init.defaultBranch = "master";
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
      ignores = [ "result" ];
      lfs.enable = true;
    };
  };
}
