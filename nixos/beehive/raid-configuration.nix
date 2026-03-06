{ config, pkgs, ... }:
{
  # Define the beehive-specific sops secret for RAID password
  sops.secrets.beehive_raid_password = {
    mode = "0400";
  };

  # Define a target that other services can depend on
  # This provides a clean synchronization point for services that need the RAID
  systemd = {
    targets.raid-online = {
      description = "RAID Array Mounted and Ready";
      after = [
        "mount-raid.service"
        "raid-permissions.service"
      ];
      requires = [
        "mount-raid.service"
        "raid-permissions.service"
      ];
      wantedBy = [ "multi-user.target" ];
      unitConfig = {
        # Ensure that services waiting for this target don't timeout too early
        # if the RAID mount takes a while (e.g. sops decryption or bcachefs fsck)
        JobTimeoutSec = "30min";
        JobTimeoutAction = "none";
      };
    };

    services = {
      mount-raid = {
        enable = true;
        description = "Mount RAID configuration";
        # Start early in the boot process
        wantedBy = [ "multi-user.target" ];
        restartIfChanged = false;

        unitConfig = {
          # Ensure sops is ready
          After = [
            "local-fs.target"
          ];
          Before = [
            "raid-online.target"
          ];
        };

        path = [
          pkgs.unstable.bcachefs-tools
          pkgs.util-linux
          pkgs.findutils
          pkgs.coreutils
          pkgs.gawk
        ];

        script =
          let
            passwordFile = config.sops.secrets.beehive_raid_password.path;
            uuid = "d9b90082-f74f-45fb-9bc9-ce571f2b8630";
          in
          ''
            set -euo pipefail

            echo "Starting RAID mount for UUID=${uuid}"

            # Ensure mount point exists
            mkdir -p /data

            # Wait for udev to settle
            udevadm settle || true

            # Skip if already mounted
            if mountpoint -q /data; then
              echo "/data already mounted, skipping."
              exit 0
            fi

            # Check if password file exists (Wait up to 30 seconds if it's missing)
            found_secret=false
            for i in {1..30}; do
              if [ -f "${passwordFile}" ]; then
                echo "Found password file ${passwordFile}."
                found_secret=true
                break
              fi
              echo "Waiting for password file ${passwordFile} (attempt $i/30)..."
              sleep 1
            done

            if [ "$found_secret" = false ]; then
              echo "Error: Password file ${passwordFile} not found after 30 seconds!"
              exit 1
            fi

            # Get the raw password (no newlines)
            PASSWORD=$(tr -d '\n\r' < "${passwordFile}")

            # Find all devices matching the UUID (use -p for full paths and -l for a flat list)
            DEVICES=$(lsblk -fnlo NAME,UUID -p | grep "${uuid}" | awk '{print $1}' || true)

            if [ -z "$DEVICES" ]; then
              echo "Error: No devices found for bcachefs RAID with UUID=${uuid}"
              exit 1
            fi

            echo "Found devices for RAID: $(echo "$DEVICES" | xargs)"

            # 1. Try to unlock each device into the session keyring
            # This is more robust for some bcachefs versions
            for dev in $DEVICES; do
              echo "Attempting to unlock $dev..."
              echo -n "$PASSWORD" | bcachefs unlock -k session "$dev" || echo "Note: Unlock failed for $dev (might be already unlocked or non-primary)"
            done

            # 2. Attempt the mount using the session keyring
            echo "Attempting to mount UUID=${uuid} to /data..."
            if bcachefs mount -k session "UUID=${uuid}" /data; then
               echo "RAID mount successful via session keyring."
            else
               echo "Mount via session keyring failed. Attempting direct mount with password and device list..."
               # Create a colon-separated list of devices
               DEV_LIST=$(echo "$DEVICES" | paste -sd ":" -)
               if echo -n "$PASSWORD" | bcachefs mount -k stdin "$DEV_LIST" /data; then
                 echo "RAID mount successful via device list."
               else
                 echo "Error: All mount attempts failed for bcachefs RAID with UUID=${uuid}"
                 exit 1
               fi
            fi

            echo "RAID mount successful."
          '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          TimeoutStartSec = "10min";
          Restart = "on-failure";
          RestartSec = "15s";
        };
      };
    };
  };
}
