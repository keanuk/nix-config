{ inputs, ... }:
{
  flake.modules.homeManager.noctalia =
    { pkgs, lib, ... }:
    {
      imports = [ inputs.noctalia.homeModules.default ];

      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        settings = ./noctalia.toml;
      };

      home.packages = [ pkgs.papirus-icon-theme ];

      gtk = {
        enable = true;
        iconTheme = {
          package = pkgs.papirus-icon-theme;
          # Noctalia's papirus-icons template recolors the plain "Papirus" variant.
          name = lib.mkDefault "Papirus";
        };
      };

      # Noctalia recolors Papirus by running papirus-folders against a writable
      # copy of the theme in ~/.local/share/icons. Its own fallback copy source
      # (/usr/share/icons) does not exist on NixOS, so seed the copy from the
      # store package; afterwards its template hook takes over.
      home.activation.papirusWritableCopy = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ ! -d "$HOME/.local/share/icons/Papirus" ]; then
          run mkdir -p "$HOME/.local/share/icons"
          run cp -r --no-preserve=mode "${pkgs.papirus-icon-theme}/share/icons/Papirus" "$HOME/.local/share/icons/Papirus"
          run chmod -R u+w "$HOME/.local/share/icons/Papirus"
        fi
      '';
    };
}
