{ self, ... }: {
  flake.modules.nixos.role-laptop = {
    imports = with self.modules.nixos; [
      role-base
      role-graphical
      power
    ];
  };

  flake.modules.homeManager.role-laptop = {
    imports = with self.modules.homeManager; [
      role-base
      role-graphical
    ];
  };
}
