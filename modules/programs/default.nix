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
  #./waybar.nix
  #./games.nix
]
# Waybar.nix is pulled from modules/desktop/..
# Games.nix is pulled from desktop/default.nix
