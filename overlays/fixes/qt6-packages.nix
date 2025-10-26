# Use stable versions of Qt6 packages to avoid build issues
# Issue: Qt6 packages fail to build due to missing GuiPrivate or CMake incompatibilities
# Workaround: Use stable versions instead of unstable
# Status: temporary - expected to be fixed with Qt6 stabilization
# Last checked: 2025-01-26
final: prev: {
  # Stellarium fails with qxlsx Qt6 build issues
  stellarium = final.stable.stellarium or prev.stellarium;

  # Protonmail Bridge GUI fails with Qt6 CMake macro issues
  protonmail-bridge-gui = final.stable.protonmail-bridge-gui or prev.protonmail-bridge-gui;
}
