# Use stable krita to avoid lager build failure with Boost 1.89
# Issue: lager-0.1.0 CMakeLists.txt uses find_package(Boost COMPONENTS system) but
#   boost_system was removed/made header-only in Boost 1.89.0, causing CMake to fail:
#   "Could not find a package configuration file provided by boost_system"
# This breaks: lager → krita-unwrapped → krita → home-manager-path → system
# Workaround: Use stable version of krita which builds against an older Boost
# Status: temporary - expected to be fixed when lager updates its CMake config
# Last checked: 2026-02-24
# Remove after: lager > 0.1.0 or nixpkgs patches lager for Boost 1.89+
final: prev: {
  krita = final.stable.krita or prev.krita;
}
