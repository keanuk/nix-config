{
  flake.modules.nixos.nfs = _: {
    services.nfs.server = {
      enable = true;
    };
    # NFS server port
    networking.firewall.allowedTCPPorts = [ 2049 ];
  };
}
