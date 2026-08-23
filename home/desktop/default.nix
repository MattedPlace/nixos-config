{ ... }: {
  imports = [
    # Desktop components
    ./terminals/default.nix
    ./terminal-apps-desktop-entries.nix

    # Core desktop modules
    ./theme/default.nix
    #./gaming/default.nix
    ./sound/default.nix

    # Desktop modules
    # ./plasma/default.nix
    #./com.nix
    ./neofetch/default.nix
    ./kdeconnect/default.nix
    ./obs/default.nix
    ./flameshot/default.nix
    ./screenshots/wayland-native.nix
    ./zathura/default.nix
    ./evince/default.nix
    ./gnome # GNOME desktop environment (optional)
  ];
}
