{ inputs, pkgs, ... }:

{
	programs.helix = {
		enable = true;
    package = inputs.helix.packages."${pkgs.system}".helix;
		defaultEditor = true;
		settings = {
			theme = "tokyonight";
			editor = {
				auto-save = true;
				bufferline = "multiple";
				color-modes = true;
				cursorline = true;
				cursorcolumn = false;
				cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
				file-picker = {
					hidden = false;
					deduplicate-links = false;
				};
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
	};
}
