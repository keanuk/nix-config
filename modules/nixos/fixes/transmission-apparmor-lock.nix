# Issue: nixpkgs `services.transmission` AppArmor profile only grants `rw` on
#   `${cfg.home}/.config/transmission-daemon/**`, but Transmission 4.1+ acquires a
#   file lock (`k`) on `.config/transmission-daemon/lock` at startup and exits after
#   25s if `file_lock` is denied by AppArmor.
# Status: active
# Last-checked: 2026-11-01
# Removal condition: Remove when nixpkgs' `nixos/modules/services/torrent/transmission.nix`
#   grants `k` (e.g. `rwk`) on `${cfg.home}/${settingsDir}/**` in
#   `security.apparmor.includes."local/bin.transmission-daemon"`.
{ config, ... }:
{
  flake.modules.nixos.transmission-apparmor-lock =
    { config, lib, ... }:
    lib.mkIf config.services.transmission.enable {
      security.apparmor.includes."local/bin.transmission-daemon" = ''
        owner ${config.services.transmission.home}/.config/transmission-daemon/** rwk,
      '';
    };

  flake.modules.nixos.nixarr = config.flake.modules.nixos.transmission-apparmor-lock;
}
