{ config
, lib
, pkgs
, ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  username = "Maxwell";
  cfg = config.services.print;
in
{
  options.services.print = {
    enable = mkEnableOption {
      default = false;
      description = "Enable the HP print service";
    };
  };
  config = mkIf cfg.enable {
    services = {
      printing.enable = true;
    };
    hardware.sane = {
      enable = true;
    };
    users.users.${username}.extraGroups = [
      "scanner"
      "lp"
    ];
  };
}
