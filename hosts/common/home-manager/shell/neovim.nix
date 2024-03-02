{ pkgs, ... }:
{
	programs.neovim = {
		enable = true;
		defaultEditor = false;
		plugins = with pkgs.vimPlugins; [
			vim-nix
		];
	};
}