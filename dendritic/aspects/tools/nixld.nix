{
  flake.modules.nixos.role-base = {
    programs.nix-ld = {
      enable = true;
      libraries = [ ];
    };
  };
}
