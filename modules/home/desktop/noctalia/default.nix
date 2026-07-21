{ config, inputs, ... }:
let
  rawJson = builtins.fromJSON (builtins.readFile ./noctalia.json);
  noctaliaSettings = rawJson.settings or rawJson;
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
    };
}
