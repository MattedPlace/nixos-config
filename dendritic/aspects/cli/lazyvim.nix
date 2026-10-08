# modules/lazyvim.nix
{inputs, ...}: {
  # Contribute a reusable home-manager aspect
  flake.modules.homeManager.lazyvim = {pkgs, ...}: {
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
        lang.go.enable = true;
        lang.rust.enable = true;
        lang.typescript.enable = true;
        lang.docker.enable = true;
      };

      treesitterParsers = with pkgs.vimPlugins.nvim-treesitter-parsers; [
        nix
        go
        gomod
        gosum
        rust
        dockerfile
      ];
      extraPackages = with pkgs; [
        # LSPs
        nixd
        lua-language-server
        typescript-language-server
        python313Packages.python-lsp-server # or pyright
        gopls
        rust-analyzer

        # Formatters
        stylua
        prettier
        python313Packages.black
        python313Packages.isort
        rustfmt

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
        luajitPackages.lpeg
        luajitPackages.luabitop
        luajitPackages.mpack
        libuv
        unibilium
        python313Packages.tomlkit

        statix
        codeium
      ];
    };
  };
}
