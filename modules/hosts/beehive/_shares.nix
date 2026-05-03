{ config, pkgs, ... }:
{
  services = {
    # NFS Server Configuration
    nfs.server = {
      enable = true;
      # Share /data with the local network
      # (rw) - Read/write
      # (nohide) - Keep submounts visible
      # (insecure) - Allow connections from ports higher than 1024
      # (no_subtree_check) - Better performance and reliability
      # (async) - Higher performance (but risky on power loss)
      # (no_root_squash) - Allow remote root to have root permissions (useful for UID matching)
      exports = ''
        /data  192.168.0.0/16(rw,nohide,insecure,no_subtree_check,async,no_root_squash) 10.0.0.0/8(rw,nohide,insecure,no_subtree_check,async,no_root_squash) 172.16.0.0/12(rw,nohide,insecure,no_subtree_check,async,no_root_squash) 100.64.0.0/10(rw,nohide,insecure,no_subtree_check,async,no_root_squash)
      '';
    };

    # SMB Server Configuration (Samba)
    # This provides better compatibility with Windows/Android, but also works well with GVFS/KIO on Linux
    samba = {
      enable = true;
      openFirewall = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "Beehive NAS";
          "netbios name" = "beehive";
          "security" = "user";
          # Allow only local network
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

    # Multicast DNS (mDNS) for easy discovery (beehive.local)
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

  # Ensure sharing services wait for RAID to be mounted
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

  # Open firewall for NFS (Samba is handled by openFirewall = true)
  networking.firewall.allowedTCPPorts = [ 2049 ];

  # Declarative Samba password setup
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
      # Use printf for safer password piping and -s for stdin input
      printf "%s\n%s\n" "$password" "$password" | ${pkgs.samba}/bin/smbpasswd -s -a keanu
    '';
  };
}
