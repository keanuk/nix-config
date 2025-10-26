# Use stable versions of packages that depend on Ruby/nokogiri to avoid build issues
# Issue: Ruby/nokogiri packages fail to build on macOS with nixpkgs-unstable
# Workaround: Use stable versions
# Status: temporary - platform-specific issue
# Last checked: 2025-01-26
final: prev: {
  bash-preexec = final.stable.bash-preexec or prev.bash-preexec;
  bats = final.stable.bats or prev.bats;
}
