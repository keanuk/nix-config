{ ... }:

{
	programs.fish = {
		enable = true;
		interactiveShellInit = ''
			function fish_greeting
				fastfetch
			end
		'';
		shellAliases = {
			cleanup = "nix-store --gc && nix-store --optimize";
			ll = "ls -l";
			rebuild = "sudo nixos-rebuild switch --upgrade";
			rebuild-offline = "sudo nixos-rebuild switch --option substitute false";
			repair = "sudo nix-store --verify --check-contents --repair";
			update = "nix flake update ~/.config/nix-config";
		};
	};
}
