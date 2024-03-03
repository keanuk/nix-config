{ config, secrets, ... }:

{
	services.resolved = { 
		enable = true;
		extraConfig = ''
			DNS=45.90.28.0#${secrets.nextdns.id}.dns.nextdns.io
			DNS=2a07:a8c0::#${secrets.nextdns.id}.dns.nextdns.io
			DNS=45.90.30.0#${secrets.nextdns.id}.dns.nextdns.io
			DNS=2a07:a8c1::#${secrets.nextdns.id}.dns.nextdns.io
			DNSOverTLS=yes
		'';
	};
}