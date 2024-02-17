{ config, pkgs, ... }:

{
	nextdns = {
		enable = true;
		arguments = [ "-config" "c773e8" ];
	};

	environment.systemPackages = with pkgs; [
		nextdns
	];
}