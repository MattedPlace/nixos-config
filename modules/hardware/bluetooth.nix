_: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        AutoEnable = false;
        ReconnectAttempts = 0;
      };
    };
  };

  services.blueman.enable = true;

}
