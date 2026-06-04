{ config, pkgs, ... }:
let
  uuid = "d9b90082-f74f-45fb-9bc9-ce571f2b8630";
  passwordFile = config.sops.secrets.ursa_raid_password.path;
  inherit (pkgs.unstable) bcachefs-tools;
in
{
  sops.secrets.ursa_raid_password = {
    mode = "0400";
  };

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
        pkgs.systemd
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
          echo "Error: ${passwordFile} not found after 60s"
          exit 1
        fi
        echo "Password file available."

        # Wait for RAID member devices to appear and stabilize.
        echo "Waiting for RAID member devices (UUID=${uuid})..."
        PREV_DEVICES=""
        STABLE_SECONDS=0

        for i in $(seq 1 180); do
          DEVICES=$(
            lsblk -fnlo NAME,UUID -p \
              | awk -v u="${uuid}" '$2 == u {print $1}' \
              | sort
          )
          COUNT=0
          if [ -n "$DEVICES" ]; then
            COUNT=$(echo "$DEVICES" | wc -l | tr -d ' ')
          fi

          if [ "$DEVICES" = "$PREV_DEVICES" ] && [ "$COUNT" -gt 0 ]; then
            STABLE_SECONDS=$((STABLE_SECONDS + 1))
          else
            STABLE_SECONDS=0
            PREV_DEVICES="$DEVICES"
          fi

          if [ $((i % 10)) -eq 0 ]; then
            echo "  wait ''${i}s: count=$COUNT, stable=''${STABLE_SECONDS}s"
          fi

          if [ "$COUNT" -ge 14 ] && [ "$STABLE_SECONDS" -ge 15 ]; then
            echo "All 14 devices present and stable for ''${STABLE_SECONDS}s."
            break
          fi

          sleep 1
        done

        if [ -z "''${DEVICES:-}" ]; then
          echo "Error: no devices found for UUID=${uuid} after 180s"
          exit 1
        fi

        COUNT=$(echo "$DEVICES" | wc -l | tr -d ' ')
        if [ "$COUNT" -lt 14 ]; then
          echo "Error: only $COUNT of 14 devices found. Refusing to mount with incomplete set."
          echo "Devices found: $(echo "$DEVICES" | xargs)"
          exit 1
        fi

        FIRST_DEV=$(echo "$DEVICES" | head -n1)
        echo "Devices: $(echo "$DEVICES" | xargs)"

        echo "Unlocking via $FIRST_DEV..."
        bcachefs unlock -f "${passwordFile}" "$FIRST_DEV" \
          || echo "Already unlocked or key already present"

        echo "Mounting UUID=${uuid} at /data..."
        bcachefs mount -k fail "UUID=${uuid}" /data
        echo "bcachefs RAID mounted at /data."

        echo "Creating base directories..."
        systemd-tmpfiles --create --prefix=/data
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
