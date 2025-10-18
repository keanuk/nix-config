{inputs, ...}: {
  imports = [
    inputs.preservation.nixosModules.preservation
  ];

  preservation = {
    enable = true;
    preserveAt."/persist" = {
      directories = [
        "/var/lib/bluetooth"
        "/var/lib/fprint"
        "/var/lib/fwupd"
        "/var/lib/libvirt"
        "/var/lib/nixos"
        "/var/lib/power-profiles-daemon"
        "/var/lib/sbctl"
        "/var/lib/systemd/coredump"
        "/var/lib/systemd/rfkill"
        "/var/lib/systemd/timers"
        "/var/log"
        "/etc/secureboot"
        "/etc/NetworkManager/system-connections"
        "/etc/nixos"
        {
          directory = "/var/lib/keanu";
          user = "keanu";
          group = "keanu";
          mode = "u=rwx,g=rx,o=";
        }
      ];
      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
          how = "symlink";
          configureParent = true;
        }
        {
          file = "/var/keys/secret_file";
          parentDirectory = {
            mode = "u=rwx,g=,o=";
          };
        }
        {
          file = "/etc/nix/id_rsa";
          parentDirectory = {
            mode = "u=rwx,g=,o=";
          };
        }
      ];
    };
  };

  # systemd-machine-id-commit.service would fail, but it is not relevant
  # in this specific setup for a persistent machine-id so we disable it
  #
  # see the firstboot example below for an alternative approach
  systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];

  # let the service commit the transient ID to the persistent volume
  systemd.services.systemd-machine-id-commit = {
    unitConfig.ConditionPathIsMountPoint = [
      ""
      "/persistent/etc/machine-id"
    ];
    serviceConfig.ExecStart = [
      ""
      "systemd-machine-id-setup --commit --root /persistent"
    ];
  };
}
