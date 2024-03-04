{ config, ... }:

{
	services.transmission = {
    enable = true;
    openFirewall = true;
    user = "keanu";
    home = "";
    settings = {
      download-dir = "";
      incomplete-dir = "";
    };
	};
}
