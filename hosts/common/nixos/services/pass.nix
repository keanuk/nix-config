{ pkgs, ... }: {
  services.passSecretService = {
    enable = true;
    package = pkgs.pass-secret-service;
  };
}
