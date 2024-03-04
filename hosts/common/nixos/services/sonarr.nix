{ config, ... }:

{
	services.sonarr = {
    enable = true;
    openFirewall = true;
	};
}
