{ config, pkgs, inputs, ... }:

{
	programs.helix = {
		enable = true;
		defaultEditor = true;
		# package = inputs.helix.packages."${pkgs.system}".helix;
		settings = {
			theme = "base16_default";
			editor = {
				auto-save = true;
				bufferline = "multiple";
				color-modes = true;
				cursorline = true;
				cursorcolumn = true;
				cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
				file-picker = {
					hidden = false;
					deduplicate-links = false;
				};
				# indent-guides.render = true;
				lsp = {
					display-inlay-hints = true;
					display-messages = true;
				};	
				scrolloff = 10;
        statusline = {
          mode.normal = "NORMAL";
          mode.insert = "INSERT";
          mode.select = "SELECT";
        };
				true-color = true;
				whitespace = {
					# characters.tab = ">";
					# characters.tabpad = "·";
					# render.tab = "all";
				};
			};
			keys = {
				insert = { };
				normal = {
					space.space = "file_picker";
				};
				select = { };
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
