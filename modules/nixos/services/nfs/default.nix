_: {
  # NFS server role. Not imported by any host (ursa configures its own NFS
  # server in _shares.nix); kept intentionally for future use.
  flake.modules.nixos.nfs = _: {
    services.nfs.server = {
      enable = true;
    };
    # NFS server port
    networking.firewall.allowedTCPPorts = [ 2049 ];
  };

  # Client mount for ursa's /data share over tailscale. Hosts that want the
  # share import this role explicitly.
  flake.modules.nixos.nfs-data = _: {
    fileSystems."/mnt/data" = {
      device = "ursa:/data";
      fsType = "nfs";
      options = [
        "rw"
        "noatime"
        "_netdev"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=600"
        "x-systemd.mount-timeout=10"
        "x-systemd.requires=tailscaled.service"
        "nfsvers=4"
      ];
    };
  };
}
