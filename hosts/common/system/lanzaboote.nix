{ config, pkgs, lib, ... }:

{
  boot = {
    # Secure Boot
    bootspec.enable = true;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader.systemd-boot.enable = lib.mkForce false;
  };
}
