# Issue: rtw88 Realtek WiFi driver disconnects under power save
# Description: Disables power saving and MSI/ASPM for rtw88 to prevent random disconnects
# Status: active
# Last-checked: 2025-05-25
# Removal condition: Remove when rtw88 driver upstream handles power save reliably on affected hardware
{
  flake.modules.nixos.rtw88-fix = {
    networking.networkmanager.wifi.powersave = false;
    boot.extraModprobeConfig = ''
      options rtw88_core disable_lps_deep=y
      options rtw88_pci disable_msi=y disable_aspm=y
      options rtw_core disable_lps_deep=y
      options rtw_pci disable_msi=y disable_aspm=y
    '';
  };
}
