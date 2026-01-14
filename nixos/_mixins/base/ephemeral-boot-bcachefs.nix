_: {
  boot.initrd.systemd.services.rollback = {
    description = "Rollback Root Filesystem to Blank Snapshot";
    wantedBy = [ "initrd.target" ];
    after = [ "persist.mount" ];
    requires = [ "persist.mount" ];
    before = [ "sysroot.mount" ];
    unitConfig.DefaultDependencies = false;
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/bin/sh -c 'bcachefs subvolume delete /persist/@root; bcachefs subvolume snapshot /persist/@root-blank /persist/@root'";
    };
  };
}
