{ config, ... }: {
  flake.modules.nixos.audio = { pkgs, config, ... }: {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.extraConfig."10-bluetooth-policy" = {
        "wireplumber.settings" = {
          "bluetooth.autoswitch" = false;
        };
      };
    };

    security.rtkit.enable = true;
    environment.systemPackages = [
      pkgs.pulsemixer
      pkgs.pavucontrol
    ];

    users.users.${config.host.user.name}.extraGroups = [ "audio" ];
  };
}
