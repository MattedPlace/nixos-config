{
  flake.modules.editors.nixvim =
    { pkgs, config, ... }:
    {
      colorschemes.tokyonight = {
        enable = true;
        settings = {
          style = "night";
          transparent = true;
        };
      };
    };
}
