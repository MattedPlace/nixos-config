{ self, config, ... }: {
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
      theme
    ];
  };

  flake.modules.homeManager.role-graphical = {
    imports = with self.modules.homeManager; [
      niri
      xdg
      dms-shell

      ghostty
      zen

      mpv
      ytmusic

      theme

    ];
  };
}
