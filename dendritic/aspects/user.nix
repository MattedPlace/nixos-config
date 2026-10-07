{ ... }: {
  flake.modules.nixos.user = { pkgs, ... }: {
    programs.fish.enable = true;
    security.sudo.wheelNeedsPassword = false;

    users.users.Maxwell = {
      isNormalUser = true;
      home = "/home/Maxwell";
      group = "users";
      shell = pkgs.fish;
      hashedPassword = "$6$9tzoSh9pK86/o/9U$ogDndtEZtWiyjS0gkJDI6j2d1sEBiBAkaX8U66Om8YTPKnhPag/bdRAjiyAC8.WtholwXkasnKTcgGLEJPfD21";
    };
  };

  flake.modules.homeManager.user = { ... }: {
    home = {
      username = "Maxwell";
      homeDirectory = "/home/Maxwell";
      stateVersion = "24.05";
      file."images/screenshots/.keep".text = "";
    };
  };
}
