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

      # Noctalia's idle behaviors only fire on idle timeouts; also lock when
      # suspend is triggered directly (lid close, systemctl suspend).
      systemd.user.services.lock-before-sleep = {
        Unit = {
          Description = "Lock session before sleep";
          Before = [ "sleep.target" ];
        };
        Service = {
          Type = "oneshot";
          ExecStart = "${lib.getExe' pkgs.systemd "loginctl"} lock-session";
        };
        Install.WantedBy = [ "sleep.target" ];
      };
    };
}
