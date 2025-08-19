{pkgs, ...}: {
  services.pass-secret-service = {
    enable = true;
    package = pkgs.pass-secret-service;
  };

  programs.password-store = {
    enable = true;
    package = pkgs.pass;
  };
}
