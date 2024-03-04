{ config, ... }:

{
	services.plex = {
    enable = true;
    openFirewall = true;
    user = "keanu";
	};
}
