#
#  Virtualisation Modules
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./virtualisation
#               ├─ default.nix *
#               └─ ...
#

[
  ./qemu.nix
  ./x11vnc.nix
]
