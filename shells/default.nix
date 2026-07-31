{
  config,
  pkgs,
  ...
}:

{
  default = pkgs.mkShell {
    packages = with pkgs; [
      vim
      git
    ];
  };
  neovim = pkgs.mkShell (import ./neovim.nix { inherit config pkgs; });
}
