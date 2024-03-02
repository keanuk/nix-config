{
	programs.helix = {
		enable = true;
		defaultEditor = true;
		settings = {
			theme = "base16_default";
			editor = {
				lsp.display-messages = true;
			};
		};
		themes = import ../theme/helix.nix;
		languages = {
			language = [
				{
					name = "go";
					auto-format = true;
				}
				{
					name = "nix";
					auto-format = true;
				}
				{
					name = "rust";
					auto-format = true;
				}
			];
		};
	};
}