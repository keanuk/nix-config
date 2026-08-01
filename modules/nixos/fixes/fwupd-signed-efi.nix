# Issue: https://github.com/NixOS/nixpkgs/issues/534574
# Description: fwupd aborts UEFI capsule updates with "fwupdx64.efi.signed cannot be
# found" under Secure Boot: nixpkgs' fwupd-efi ships only the unsigned helper and
# fwupd requires the signed one (fu-uefi-common.c, fu_uefi_get_built_app_path).
# lanzaboote's module already signs the helper into /run/fwupd-efi and points the
# daemon there via FWUPD_EFIAPPDIR, but fwupd 2.1.x dropped that env override
# (libfwupdplugin/fu-path-store.c) and still reads the build-time EFI_APP_LOCATION,
# i.e. the read-only store dir. Overlay the signed runtime dir onto that store dir
# in fwupd.service's mount namespace.
# Status: active
# Last-checked: 2026-08-01
# Removal condition: Remove when fwupd honors FWUPD_EFIAPPDIR again (making
# lanzaboote's existing /run/fwupd-efi redirect work) or when lanzaboote's module
# places the signed helper where fwupd actually looks.
{ config, ... }:
{
  flake.modules.nixos.fwupd-signed-efi =
    { config, lib, ... }:
    lib.mkIf (config.boot.lanzaboote.enable && config.services.fwupd.enable) {
      # /run/fwupd-efi (signed helper + symlinked unsigned one) is populated by
      # lanzaboote's fwupd-efi.service, which is ordered before fwupd.service.
      systemd.services.fwupd.serviceConfig.BindPaths = [
        "/run/fwupd-efi:${config.services.fwupd.package.fwupd-efi}/libexec/fwupd/efi"
      ];
    };

  # Every secure-boot (lanzaboote) host needs this for capsule updates.
  flake.modules.nixos.lanzaboote = config.flake.modules.nixos.fwupd-signed-efi;
}
