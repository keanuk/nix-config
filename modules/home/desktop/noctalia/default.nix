{ config, inputs, ... }:
let
  noctaliaSettings = fromTOML (builtins.readFile ./noctalia.toml);
in
{
  perSystem =
    { pkgs, ... }:
    let
      noctaliaPkg = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default or pkgs.hello;
    in
    {
      packages.myNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
        inherit pkgs;
        package = noctaliaPkg;
        settings = noctaliaSettings;
      };
    };

  flake.modules.homeManager.noctalia =
    {
      pkgs,
      lib,
      ...
    }:
    let
      self' = config.perSystem pkgs.stdenv.hostPlatform.system;
    in
    {
      imports = [ inputs.noctalia.homeModules.default ];

      programs.noctalia = {
        enable = true;
        package = self'.packages.myNoctalia;
        systemd.enable = lib.mkDefault true;
        settings = noctaliaSettings;
      };

      home.packages = [ pkgs.papirus-icon-theme ];

      gtk = {
        enable = true;
        iconTheme = {
          package = pkgs.papirus-icon-theme;
          name = lib.mkDefault "Papirus-Dark";
        };
      };

      services.hypridle = {
        enable = lib.mkDefault true;
        settings = {
          general = {
            lock_cmd = "${lib.getExe self'.packages.myNoctalia} msg session lock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "${lib.getExe self'.packages.myNoctalia} msg session dpms-on";
          };
          listener = [
            {
              timeout = 300;
              on-timeout = "loginctl lock-session";
            }
          ];
        };
      };
    };
}
