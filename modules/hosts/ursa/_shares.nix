{ config, pkgs, ... }:
{
  services = {
    nfs.server = {
      enable = true;
      lockdPort = 4001;
      mountdPort = 4002;
      statdPort = 4003;
      exports = ''
        /data  192.168.0.0/16(rw,nohide,insecure,no_subtree_check,async,no_root_squash) 10.0.0.0/8(rw,nohide,insecure,no_subtree_check,async,no_root_squash) 172.16.0.0/12(rw,nohide,insecure,no_subtree_check,async,no_root_squash) 100.64.0.0/10(rw,nohide,insecure,no_subtree_check,async,no_root_squash)
      '';
    };

    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "Ursa NAS";
          "netbios name" = "ursa";
          "security" = "user";
          "hosts allow" = "127.0.0.1 192.168.0.0/16 10.0.0.0/8 172.16.0.0/12 100.64.0.0/10";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
        "data" = {
          "path" = "/data";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "keanu";
          "force group" = "media";
        };
      };
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        userServices = true;
      };
    };
  };

  systemd.services = {
    nfs-server = {
      after = [ "raid-online.target" ];
      requires = [ "raid-online.target" ];
    };
    samba-smbd = {
      after = [ "raid-online.target" ];
      requires = [ "raid-online.target" ];
    };
  };

  networking.firewall.allowedTCPPorts = [
    111
    2049
    4001
    4002
    4003
  ];
  networking.firewall.allowedUDPPorts = [
    111
    2049
    4001
    4002
    4003
  ];

  sops.secrets.samba-password = { };

  systemd.services.samba-setup = {
    description = "Samba user setup";
    after = [
      "samba-smbd.service"
      "local-fs.target"
    ];
    wants = [
      "samba-smbd.service"
      "local-fs.target"
    ];
    wantedBy = [ "multi-user.target" ];
    restartTriggers = [ config.sops.secrets.samba-password.path ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if [ ! -f ${config.sops.secrets.samba-password.path} ]; then
        echo "Error: Samba password secret not found at ${config.sops.secrets.samba-password.path}"
        exit 1
      fi
      password=$(cat ${config.sops.secrets.samba-password.path})
      printf "%s\n%s\n" "$password" "$password" | ${pkgs.samba}/bin/smbpasswd -s -a keanu
    '';
  };
}
