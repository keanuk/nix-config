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
          name = lib.mkDefault "Papirus-Dark";
        };
      };
    };
}
