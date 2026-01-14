{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.pass-secret-service = {
    enable = true;
    package = pkgs.pass-secret-service;
    storePath = lib.mkForce "${config.home.homeDirectory}/.password-store";
  };

  programs.password-store = {
    enable = true;
    package = pkgs.pass;
  };
}
