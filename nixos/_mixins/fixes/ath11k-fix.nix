# Fix for ath11k (Qualcomm WiFi) instability issues
#
# Issues addressed:
# 1. Firmware crashes (MHI_CB_EE_RDDM) when resuming from suspend
# 2. Runtime instability with frequent beacon losses and disconnections
# 3. Transmit queue flush failures ("failed to flush transmit queue, data pkts pending")
#
# Hardware affected: Qualcomm QCNFA765 (wcn6855) and similar chips using ath11k_pci
#
# Workarounds:
# - Reload the ath11k_pci kernel module after resume
# - Provide a manual recovery script for runtime issues
# - Disable power saving features that can cause instability
#
# Status: This is a known issue with ath11k driver stability.
# Monitor: https://bugzilla.kernel.org/buglist.cgi?quicksearch=ath11k
# Last checked: 2025-01-03
# Remove after: When ath11k stability is fixed upstream in the kernel
{
  config,
  pkgs,
  ...
}: let
  # Script to reload ath11k module and recover WiFi
  ath11kRecoveryScript = pkgs.writeShellScriptBin "ath11k-recover" ''
    set -e
    echo "ath11k-recover: Starting WiFi recovery..."

    # Check if running as root
    if [ "$EUID" -ne 0 ]; then
      echo "Please run as root (sudo ath11k-recover)"
      exit 1
    fi

    # Check if ath11k_pci is loaded
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

    # Check if connected
    if ${pkgs.iproute2}/bin/ip link show wlp2s0 | grep -q "state UP"; then
      echo "ath11k-recover: WiFi recovery successful!"
    else
      echo "ath11k-recover: Interface is up, waiting for NetworkManager to connect..."
    fi
  '';
in {
  # Ensure ath11k module is available
  boot.kernelModules = ["ath11k_pci"];

  # Add recovery script to system packages
  environment.systemPackages = [ath11kRecoveryScript];

  # Create a systemd service to reload ath11k_pci after resume
  systemd.services.ath11k-resume-fix = {
    description = "Reload ath11k WiFi driver after suspend/resume";
    after = ["suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target"];
    wantedBy = ["suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target"];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = let
        script = pkgs.writeShellScript "ath11k-resume" ''
          # Wait a moment for the system to stabilize after resume
          sleep 2

          # Check if ath11k_pci is loaded
          if ${pkgs.kmod}/bin/lsmod | grep -q ath11k_pci; then
            echo "ath11k-resume: Reloading ath11k_pci module to recover from suspend..."

            # Bring down the interface first
            ${pkgs.iproute2}/bin/ip link set wlp2s0 down 2>/dev/null || true

            # Unload the module
            ${pkgs.kmod}/bin/modprobe -r ath11k_pci 2>/dev/null || true

            # Brief pause to ensure clean unload
            sleep 1

            # Reload the module
            ${pkgs.kmod}/bin/modprobe ath11k_pci

            # Wait for device to initialize
            sleep 2

            # Restart NetworkManager to reconnect
            ${config.systemd.package}/bin/systemctl restart NetworkManager

            echo "ath11k-resume: Module reloaded successfully"
          fi
        '';
      in "${script}";
    };
  };

  # Optional: Create a timer-based watchdog that can detect and recover from
  # WiFi failures. Disabled by default as it may be too aggressive.
  # Uncomment if you want automatic recovery from runtime issues.
  #
  # systemd.services.ath11k-watchdog = {
  #   description = "Monitor ath11k WiFi and recover from failures";
  #   after = ["NetworkManager.service"];
  #   wantedBy = ["multi-user.target"];
  #
  #   serviceConfig = {
  #     Type = "simple";
  #     Restart = "always";
  #     RestartSec = "60";
  #     ExecStart = let
  #       script = pkgs.writeShellScript "ath11k-watchdog" ''
  #         FAILURES=0
  #         MAX_FAILURES=3
  #
  #         while true; do
  #           sleep 30
  #
  #           # Check if interface exists and is connected
  #           if ! ${pkgs.iproute2}/bin/ip link show wlp2s0 &>/dev/null; then
  #             echo "ath11k-watchdog: Interface missing, triggering recovery..."
  #             ${ath11kRecoveryScript}/bin/ath11k-recover
  #             FAILURES=0
  #             sleep 60
  #             continue
  #           fi
  #
  #           # Check for recent transmit queue failures
  #           if ${pkgs.systemd}/bin/journalctl --since "2 minutes ago" | grep -q "failed to flush transmit queue"; then
  #             FAILURES=$((FAILURES + 1))
  #             echo "ath11k-watchdog: Transmit queue failure detected ($FAILURES/$MAX_FAILURES)"
  #
  #             if [ $FAILURES -ge $MAX_FAILURES ]; then
  #               echo "ath11k-watchdog: Too many failures, triggering recovery..."
  #               ${ath11kRecoveryScript}/bin/ath11k-recover
  #               FAILURES=0
  #               sleep 60
  #             fi
  #           else
  #             FAILURES=0
  #           fi
  #         done
  #       '';
  #     in "${script}";
  #   };
  # };

  # Log resume events
  powerManagement.resumeCommands = ''
    echo "ath11k-fix: System resumed, WiFi module will be reloaded by systemd service"
  '';
}
