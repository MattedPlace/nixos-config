{ lib, config, ... }: {
  flake.modules.nixos.time = { config, ... }: {
    # Allow the timezone to be set dynamically
    time.timeZone = lib.mkDefault null; # or just remove any time.timeZone line

    # Automatic timezone from location
    services.automatic-timezoned.enable = true;

    # GeoClue (already defaults to beaconDB now)
    services.geoclue2 = {
      enable = true;
      # Default is already https://api.beacondb.net/v1/geolocate
      # You can leave this out unless you want a different provider
      # geoProviderUrl = "https://api.beacondb.net/v1/geolocate";
    };

    # Optional but recommended: let location services work properly
    location.provider = "geoclue2";
  };
}
