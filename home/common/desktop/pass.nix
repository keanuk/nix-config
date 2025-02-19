{ pkgs, ... }:

{
  services = {
    gnome-keyring.enable = true;
    pass-secret-service = {
      enable = true;
      package = pkgs.pass-secret-service;
    };
  };

  programs.password-store = {
    enable = true;
    package = pkgs.pass-wayland;
  };

  home.packages = with pkgs; [
    gcr_4
  ];
}
