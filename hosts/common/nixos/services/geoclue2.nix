{ config, secrets, ... }:

{
	services.geoclue2 = {
		enable = true;
		geoProviderUrl = "https://www.googleapis.com/geolocation/v1/geolocate?key=${secrets.google_maps.token}";
	};
}