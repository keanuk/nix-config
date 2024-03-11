{ ... }:

{
	programs.zsh = {
		enable = true;
		autocd = true;
		enableCompletion = true;
		enableAutosuggestions = true;
		shellAliases = {
			cleanup = "nix-store --gc && nix-store --optimize";
			ll = "ls -l";
			rebuild = "sudo nixos-rebuild switch --upgrade";
			repair = "sudo nix-store --verify --check-contents --repair";
			update = "nix flake update ~/.config/nixos-config";
		};
		oh-my-zsh = {
			enable = true;
			theme = "fletcherm";
			plugins = [
				"gh"
				"git"
				"golang"
				"rust"
				"sudo"
				"systemd"
			];
		};
	};
}
