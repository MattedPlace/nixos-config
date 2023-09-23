#
#  Apps
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ home.nix
#   └─ ./modules
#       └─ ./apps
#           └─ default.nix *
#               └─ ...
#

[
  ./chromium.nix
  ./alacritty.nix
  ./rofi.nix
  ./wofi.nix
  ./ranger.nix
  ./waybar.nix
  ./eww.nix
  #./flatpak.nix
  ./games.nix
]
