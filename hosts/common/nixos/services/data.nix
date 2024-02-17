{ config, pkgs, lib, ... }:

{
  services = {
    nextcloud = {
      enable = true;
      hostName = builtins.getEnv "HOST";
    };

    nfs.server = {
      enable = true;
    };

    samba = {
      enable = true;
    };
  };
}