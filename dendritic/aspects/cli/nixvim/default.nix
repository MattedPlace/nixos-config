{
  config,
  inputs,
  ...
}: let
  nixvimConfig = pkgs: {
    enable = true;
    nixpkgs.pkgs = pkgs;
    imports = [config.flake.modules.editors.nixvim];
  };

  packages = pkgs:
    with pkgs; [
      cargo
      deno
      beamPackages.elixir
      beamPackages.erlang
      git
      go
      nodejs
      (python3.withPackages (
        ps:
          with ps; [
            pip
          ]
      ))
      ripgrep
      rustc
      # zig
      inputs.zig.packages.${pkgs.stdenv.hostPlatform.system}.master
    ];

  npmEnvironment = {config, ...}: {
    home.file.".npmrc".text = ''
      prefix=${config.home.homeDirectory}/.npm-packages
    '';

    home.sessionPath = [
      "${config.home.homeDirectory}/.npm-packages/bin"
    ];

    home.sessionVariables = {
      PATH = "${config.home.homeDirectory}/.npm-packages/bin:$PATH";
      NODE_PATH = "${config.home.homeDirectory}/.npm-packages/lib/node_modules:$NODE_PATH:";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
in {
  flake.modules.nixos.nixvim = {pkgs, ...}: {
    imports = [
      inputs.nixvim.nixosModules.nixvim
    ];
    programs.nixvim = nixvimConfig pkgs;
    environment.systemPackages = packages pkgs;
    home-manager.users.Maxwell = {
      imports = [npmEnvironment];
    };
  };

  flake.modules.homeManager.nixvim = {pkgs, ...}: {
    imports = [
      inputs.nixvim.homeModules.nixvim
      npmEnvironment
    ];
    programs.nixvim = nixvimConfig pkgs;
    home.packages = packages pkgs;
  };
}
