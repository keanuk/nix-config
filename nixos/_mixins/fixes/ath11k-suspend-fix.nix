# Fix for ath11k (Qualcomm WiFi) firmware crashes after suspend/resume
# Issue: The ath11k firmware crashes (MHI_CB_EE_RDDM) when resuming from suspend,
# causing WiFi connectivity issues for 1-2 minutes while the driver recovers.
#
# Hardware affected: Qualcomm QCNFA765 (wcn6855) and similar chips using ath11k_pci
#
# Workaround: Reload the ath11k_pci kernel module after resume to ensure
# clean firmware initialization.
#
# Status: This is a known issue with ath11k driver suspend/resume support.
# Monitor: https://bugzilla.kernel.org/buglist.cgi?quicksearch=ath11k%20suspend
# Last checked: 2025-01-01
# Remove after: When ath11k suspend/resume is fixed upstream in the kernel
{
  config,
  pkgs,
  ...
}: {
  # Ensure ath11k module is available
  boot.kernelModules = ["ath11k_pci"];

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

          # Check if ath11k_pci is loaded and having issues
          if ${pkgs.kmod}/bin/lsmod | grep -q ath11k_pci; then
            echo "Reloading ath11k_pci module to recover from suspend..."

            # Bring down the interface first
            ${pkgs.iproute2}/bin/ip link set wlp2s0 down 2>/dev/null || true

            # Unload the modules (ath11k_pci depends on ath11k)
            ${pkgs.kmod}/bin/modprobe -r ath11k_pci 2>/dev/null || true

            # Brief pause to ensure clean unload
            sleep 1

            # Reload the module
            ${pkgs.kmod}/bin/modprobe ath11k_pci

            # Wait for device to initialize
            sleep 2

            # Restart NetworkManager to reconnect
            ${config.systemd.package}/bin/systemctl restart NetworkManager

            echo "ath11k_pci module reloaded successfully"
          fi
        '';
      in "${script}";
    };
  };

  # Alternative/additional fix: Use power management hooks
  powerManagement.resumeCommands = ''
    # Log that we're attempting the ath11k fix
    echo "ath11k-suspend-fix: System resumed, WiFi module will be reloaded by systemd service"
  '';
}
