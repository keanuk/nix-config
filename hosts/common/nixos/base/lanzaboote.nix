{ config, lib, inputs, ... }:

{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote  
  ];
  
  boot = {
    bootspec.enable = true;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader.systemd-boot.enable = lib.mkForce false;
  };
}
