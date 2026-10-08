{...}: {
  flake.modules.nixos.git = {pkgs, ...}: {
    environment.systemPackages = [pkgs.git-crypt];
  };

  flake.modules.homeManager.git = {pkgs, ...}: {
    home.packages = [pkgs.lazygit];

    programs.git = {
      enable = true;
      settings = {
        user.name = "Maxwell Mattila";
        init.defaultBranch = "master";
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
      ignores = ["result"];
      lfs.enable = true;
    };
  };
}
