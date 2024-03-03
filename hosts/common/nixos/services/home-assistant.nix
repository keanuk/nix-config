{ config, ... }:

{
	services.home-assistant = {
		enable = true;
		config = ./home-assistant/config/configuration.yaml;
	};
}