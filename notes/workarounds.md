# Workarounds

## Disabled packages
- pitivi: desktop/packages.nix

## Services

### geoclue
- Problem: provides incorrect location and time zone
- Workaround: changed location provider from Mozilla location services to Google 
- File: services/geoclue2.nix

### Hyprland
- Problem: build failure
- Workaround: changed flake input URL
- File: flake.nix


### NetworkManager-wait-online
- Problem: breaks `nixos-rebuild switch`
- Workaround: quit at startup
- File: base/default.nix 
