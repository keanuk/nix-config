{ config, pkgs, lib, ... }

{
  services = {
    
    nextcloud = {
      enable = true;
    };

    nfs.server = {
      enable = true;
    };

    samba = {
      enable = true;
    };
  
  };
}