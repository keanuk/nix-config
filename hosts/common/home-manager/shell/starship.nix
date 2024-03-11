{ ... }:

{
	programs.starship = {
		enable = true;
		enableTransience = true;
		settings = import ../theme/starship.nix;
	};
}
