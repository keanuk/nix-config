{ config, ... }:

{
	services.lidarr = {
		enable = true;
    openFirewall = true;
  };
}
