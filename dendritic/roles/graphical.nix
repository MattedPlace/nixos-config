{ self, ... }: {
  flake.modules.nixos.role-graphical = {
    imports = with self.modules.nixos; [
      niri
      dms-shell
      dms-greeter

      ytmusic
      zen

      audio

      cliphist
      fonts
      gvfs
      portals
      wlclipboard
    ];
  };

  flake.modules.homeManager.role-graphical = {
    imports = with self.modules.homeManager; [
      niri
      xdg

      ghostty
      nautilus
      zen

      mpv
      ytmusic

    ];
  };
}
