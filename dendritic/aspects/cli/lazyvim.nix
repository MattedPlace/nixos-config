# modules/lazyvim.nix
{ inputs, ... }: {
  # Contribute a reusable home-manager aspect
  flake.modules.homeManager.lazyvim = { pkgs, ... }: {
    # Make the home-manager module available
    imports = [
      inputs.lazyvim.homeManagerModules.default
    ];
    programs.lazyvim = {
      enable = true;

      # Point at your existing LazyVim config directory
      configFiles = ./lazyvim; # relative to this file, or use an absolute path / flake input

      extras = {
        lang.nix.enable = true;
        lang.python.enable = true;
      };

      treesitterParsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
        nix
      ];
      extraPackages = with pkgs; [
        # LSPs
        nixd
        python313Packages.python-lsp-server # or pyright

        # Formatters
        prettier
        alejandra
        nixfmt
        python313Packages.black
        python313Packages.isort

        # Tools
        ripgrep
        fd
        git
        lazygit
        tree-sitter
        curl
        unzip
        wget
        gcc
        libuv
        unibilium
        python313Packages.tomlkit

        statix
        codeium
      ];
    };
  };
}
