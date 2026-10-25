{ config, ... }: {
  flake.modules.nixos.user = { pkgs, config, ... }: {
    programs.fish.enable = true;
    security.sudo.wheelNeedsPassword = false;
    security.polkit.enable = true;

    users.users.${config.host.user.name} = {
      isNormalUser = true;
      home = "/home/${config.host.user.name}";
      group = "users";
      shell = pkgs.fish;
      hashedPassword = "$6$9tzoSh9pK86/o/9U$ogDndtEZtWiyjS0gkJDI6j2d1sEBiBAkaX8U66Om8YTPKnhPag/bdRAjiyAC8.WtholwXkasnKTcgGLEJPfD21";
      extraGroups = [
        "wheel"
        "video"
        "audio"
        "camera"
        "networkmanager"
        "lp"
        "scanner"
      ];
    };
    environment.systemPackages = with pkgs; [
      #gnome-control-center
      gnome-online-accounts
    ];

    services.gnome.gnome-keyring.enable = true;

    security.pam.services.gnomekey.enableGnomeKeyring = true;

    /*
      home-manager.users.${config.host.user.name} = {
        xdg.desktopEntries.gnome-control-center = {
          name = "Gnome Control Center";
          exec = "env XDG_CURRENT_DESKTOP=GNOME ${pkgs.gnome-control-center}/bin/gnome-control-center";
        };
      };
    */
  };
}
