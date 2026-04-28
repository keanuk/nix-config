{
  flake.modules.nixos.ath11k =
    {
      config,
      pkgs,
      ...
    }:
    let
      ath11kRecoveryScript = pkgs.writeShellScriptBin "ath11k-recover" ''
        set -e
        echo "ath11k-recover: Starting WiFi recovery..."

        if [ "$EUID" -ne 0 ]; then
          echo "Please run as root (sudo ath11k-recover)"
          exit 1
        fi

        if ! ${pkgs.kmod}/bin/lsmod | grep -q ath11k_pci; then
          echo "ath11k_pci module not loaded, loading it now..."
          ${pkgs.kmod}/bin/modprobe ath11k_pci
          sleep 2
          ${config.systemd.package}/bin/systemctl restart NetworkManager
          echo "Done."
          exit 0
        fi

        echo "Bringing down WiFi interface..."
        ${pkgs.iproute2}/bin/ip link set wlp2s0 down 2>/dev/null || true

        echo "Stopping NetworkManager..."
        ${config.systemd.package}/bin/systemctl stop NetworkManager || true
        sleep 1

        echo "Unloading ath11k_pci module..."
        ${pkgs.kmod}/bin/modprobe -r ath11k_pci 2>/dev/null || {
          echo "Warning: Could not unload module cleanly, forcing..."
          sleep 2
          ${pkgs.kmod}/bin/modprobe -r --force ath11k_pci 2>/dev/null || true
        }

        echo "Waiting for clean state..."
        sleep 2

        echo "Reloading ath11k_pci module..."
        ${pkgs.kmod}/bin/modprobe ath11k_pci

        echo "Waiting for firmware initialization..."
        sleep 3

        echo "Starting NetworkManager..."
        ${config.systemd.package}/bin/systemctl start NetworkManager

        echo "Waiting for connection..."
        sleep 5

        if ${pkgs.iproute2}/bin/ip link show wlp2s0 | grep -q "state UP"; then
          echo "ath11k-recover: WiFi recovery successful!"
        else
          echo "ath11k-recover: Interface is up, waiting for NetworkManager to connect..."
        fi
      '';
    in
    {
      boot.kernelModules = [ "ath11k_pci" ];

      environment.systemPackages = [ ath11kRecoveryScript ];

      systemd.services.ath11k-resume-fix = {
        description = "Reload ath11k WiFi driver after suspend/resume";
        after = [
          "suspend.target"
          "hibernate.target"
          "hybrid-sleep.target"
          "suspend-then-hibernate.target"
        ];
        wantedBy = [
          "suspend.target"
          "hibernate.target"
          "hybrid-sleep.target"
          "suspend-then-hibernate.target"
        ];

        serviceConfig = {
          Type = "oneshot";
          ExecStart =
            let
              script = pkgs.writeShellScript "ath11k-resume" ''
                sleep 2

                if ${pkgs.kmod}/bin/lsmod | grep -q ath11k_pci; then
                  echo "ath11k-resume: Reloading ath11k_pci module to recover from suspend..."

                  ${pkgs.iproute2}/bin/ip link set wlp2s0 down 2>/dev/null || true

                  ${pkgs.kmod}/bin/modprobe -r ath11k_pci 2>/dev/null || true

                  sleep 1

                  ${pkgs.kmod}/bin/modprobe ath11k_pci

                  sleep 2

                  ${config.systemd.package}/bin/systemctl restart NetworkManager

                  echo "ath11k-resume: Module reloaded successfully"
                fi
              '';
            in
            "${script}";
        };
      };

      powerManagement.resumeCommands = ''
        echo "ath11k-fix: System resumed, WiFi module will be reloaded by systemd service"
      '';
    };
}
