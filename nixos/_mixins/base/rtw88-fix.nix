# Realtek RTW88 Wi-Fi Workarounds
# Hardware-specific fix for devices with Realtek RTW88 wireless chipsets.
# Disables power-save features that cause connectivity issues.
#
# Import this only on hosts with RTW88 hardware.
_: {
  networking.networkmanager.wifi.powersave = false;
  boot.extraModprobeConfig = ''
    options rtw88_core disable_lps_deep=y
    options rtw88_pci disable_msi=y disable_aspm=y
    options rtw_core disable_lps_deep=y
    options rtw_pci disable_msi=y disable_aspm=y
  '';
}
