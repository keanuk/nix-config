{
  pkgs,
  secrets,
  ...
}: {
  services.geoclue2 = {
    enable = true;
    package = pkgs.geoclue2;
    # geoProviderUrl = "https://www.googleapis.com/geolocation/v1/geolocate?key=${secrets.google_maps.token}";
  };

  location.provider = "geoclue2";
}
