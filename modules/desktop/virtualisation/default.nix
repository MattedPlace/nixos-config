#
#  Specific system configuration settings for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./desktop
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./virtualisation
#               └─ default.nix *
#

[
  ./docker.nix
  ./waydroid.nix
  ./qemu.nix
  ./x11vnc.nix
]
