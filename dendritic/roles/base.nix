{ self, ... }: {
  flake.modules.nixos.role-base = {
    # electron-40.10.5: pulled in by an Electron-based app (Vesktop and/or
    # Obsidian/ytmdesktop); remove once nixpkgs moves past this EOL version.

    imports = with self.modules.nixos; [
      user

      git

      fish
      #nvf
      #nixvim
      zoxide

      print
      locale
      nix-settings
      time
      bluetooth

      nh
      ripgrep
      systemd-manager

      avahi
      steam
      packages
      samba

    ];
  };

  flake.modules.homeManager.role-base = {
    imports = with self.modules.homeManager; [
      user

      git

      btop
      carapace
      fish
      fzf
      just
      nix-index
      atuin
      #nvf
      lazyvim
      starship
      zoxide
      ranger

      env
      brave

      packages
    ];
  };
}
