{ self, ... }: {
  flake.modules.nixos.role-base = {
    nixpkgs.config.allowUnfree = true;
    # electron-40.10.5: pulled in by an Electron-based app (Vesktop and/or
    # Obsidian/ytmdesktop); remove once nixpkgs moves past this EOL version.
    nixpkgs.config.permittedInsecurePackages = [ "electron-40.10.5" ];

    imports = with self.modules.nixos; [
      user

      git
      zellij

      fish
      #nvf
      nixvim
      zoxide

      print
      locale
      nix-settings
      time

      nh
      ripgrep
      ranger
      systemd-manager

      avahi
      steam
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
      #nvf
      starship
      zellij
      zoxide

      env
      brave
    ];
  };
}
