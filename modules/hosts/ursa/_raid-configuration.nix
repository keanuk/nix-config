{ config, pkgs, ... }:
let
  uuid = "d9b90082-f74f-45fb-9bc9-ce571f2b8630";
  passwordFile = config.sops.secrets.ursa_raid_password.path;
  inherit (pkgs.unstable) bcachefs-tools;
in
{
  # bcachefs encrypted array, 2 data replicas, mounted at /data.
  #   - 12 HDDs in group `hdd` (hdd.{8tb,16tb,20tb,22tb}N) — durable storage
  #   - 2 NVMe SSDs in group `nvme` (nvme.1tb{1,2}) — write cache + read cache
  # Tier targets (persisted in the bcachefs superblock via `set-fs-option`):
  #   foreground_target=nvme  promote_target=nvme  background_target=hdd
  # New writes land on the NVMes; the rebalance thread mirrors them to the
  # HDDs in the background; hot HDD reads promote a cached copy to NVMe.
  # Device membership and targets are stored on disk by bcachefs itself, so
  # no Nix-side device list is needed here — `mount-raid` just unlocks and
  # mounts the whole filesystem by UUID and all members come online.

  # Ensure essential top-level directories exist with correct ownership after mount
  systemd.tmpfiles.rules = [
    "d /data 0775 root media -"
    "d /data/nixarr 2775 root media -"
  ];

  systemd = {
    targets.raid-online = {
      description = "RAID Array Mounted and Ready";
      after = [ "mount-raid.service" ];
      requires = [ "mount-raid.service" ];
      wantedBy = [ "multi-user.target" ];
      unitConfig = {
        JobTimeoutSec = "30min";
        JobTimeoutAction = "none";
      };
    };

    services.mount-raid = {
      description = "Unlock and mount bcachefs RAID array at /data";
      wantedBy = [ "multi-user.target" ];
      restartIfChanged = false;

      unitConfig = {
        After = [
          "local-fs.target"
          "systemd-udev-settle.service"
        ];
        Wants = [
          "systemd-udev-settle.service"
        ];
        Before = [ "raid-online.target" ];
        StartLimitIntervalSec = "15min";
        StartLimitBurst = 3;
      };

      path = [
        bcachefs-tools
        pkgs.util-linux
        pkgs.coreutils
        pkgs.gawk
      ];

      script = ''
        set -euo pipefail

        if mountpoint -q /data; then
          echo "/data is already mounted, nothing to do."
          exit 0
        fi

        mkdir -p /data

        echo "Waiting for password file..."
        for i in $(seq 1 60); do
          [ -f "${passwordFile}" ] && break
          sleep 1
        done
        if [ ! -f "${passwordFile}" ]; then
          echo "Error: ${passwordFile} not found after 60s" >&2
          exit 1
        fi
        echo "Password file available."

        # Wait for at least one bcachefs member device to surface.
        # Direct SATA/PCIe does not re-enumerate like USB, so no stability
        # tracking is needed — presence after udev settle is authoritative.
        echo "Waiting for bcachefs member device (UUID=${uuid})..."
        DEVICES=""
        for i in $(seq 1 60); do
          DEVICES=$(
            lsblk -fnlo NAME,UUID -p \
              | awk -v u="${uuid}" '$2 == u {print $1}' \
              | sort
          )
          if [ -n "$DEVICES" ]; then
            COUNT=$(echo "$DEVICES" | wc -l | tr -d ' ')
            echo "Found $COUNT member device(s): $(echo "$DEVICES" | xargs)"
            break
          fi
          sleep 1
        done

        if [ -z "$DEVICES" ]; then
          echo "Error: no bcachefs member devices found for UUID=${uuid} after 60s" >&2
          exit 1
        fi

        FIRST_DEV=$(echo "$DEVICES" | head -n1)

        # bcachefs unlock adds the key to the session keyring; KeyringMode=inherit
        # on this unit shares PID 1's keyring so mount(2) can find it.
        echo "Unlocking via $FIRST_DEV..."
        bcachefs unlock -f "${passwordFile}" "$FIRST_DEV" \
          || echo "Already unlocked or key already present"

        # Mount the array; bcachefs will assemble a degraded set when needed
        # since the filesystem has 2 replicas of everything.
        echo "Mounting UUID=${uuid} at /data..."
        bcachefs mount -k fail "UUID=${uuid}" /data
        echo "bcachefs RAID mounted at /data."

        # Materialize only the dirs we own. Do NOT run `systemd-tmpfiles
        # --create --prefix=/data` here — that scans every downstream rule
        # under /data (nextcloud, forgejo, jellyfin dirs...) and trips
        # "unsafe path transition" on pre-existing dirs whose parent+child
        # have different owners (left over from beehive's migration). The
        # tmpfiles binary returns CANTCREAT (73); under `set -e` that kills
        # mount-raid even though the mount itself succeeded, which cascades
        # into every requires=raid-online.target service at boot. Other
        # services manage their own state dirs via their modules.
        mkdir -p /data/nixarr
        chown root:media /data/nixarr 2>/dev/null || true
        chmod 2775 /data/nixarr 2>/dev/null || true
      '';

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        TimeoutStartSec = "30min";
        TimeoutStopSec = "5min";
        KillMode = "control-group";
        Restart = "on-failure";
        RestartSec = "30s";
        # bcachefs unlock adds the encryption key to the process's session
        # keyring; default KeyringMode=private would isolate it so the
        # kernel cannot see it during the mount(2) syscall.
        KeyringMode = "inherit";
      };
    };
  };
}
