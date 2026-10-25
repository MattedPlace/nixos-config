{
  flake.modules.editors.nixvim =
    { pkgs, config, ... }:
    {
      extraPackages = with pkgs; [
        eslint_d
        pylint
      ];

      plugins = {
        lint = {
          enable = true;
          lintersByFt = {
            javascript = [ "eslint_d" ];
            typescript = [ "eslint_d" ];
            svelte = [ "eslint_d" ];
            python = [ "pylint" ];
          };
        };
      };
    };
}
