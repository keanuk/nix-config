{ inputs, ... }:
{
  flake.modules.nixos.noctalia =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      imports = [
        inputs.noctalia-greeter.nixosModules.default
      ];

      programs.noctalia = {
        enable = true;
        recommendedServices.enable = true;
        package = lib.mkDefault inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };

      # greetd-based greeter; no display manager needed alongside it.
      programs.noctalia-greeter.enable = true;

      # Unlock the GNOME keyring with the password entered at the greeter.
      # Requires the keyring password to match the login password.
      #
      # Workaround: nixpkgs' greetd module authenticates via the `login` PAM
      # service (useDefaultRules = false + `auth substack login`), so the
      # keyring/fingerprint rules live in `login`, not `greetd` — setting
      # enableGnomeKeyring or reordering rules on `greetd` has no effect.
      # In `login`'s auth stack pam_fprintd is 'sufficient' and runs before
      # pam_unix, so a successful fingerprint scan skips the password modules,
      # PAM_AUTHTOK is never set, and the session's pam_gnome_keyring
      # auto_start has no password to unlock with. Move the password prompt
      # (unix-early, which sets PAM_AUTHTOK) and the keyring capture before
      # fprintd. Also applies to console login (getty uses `login` too):
      # password is prompted before fingerprint there as well.
      # Ref: https://github.com/NixOS/nixpkgs/commit/f941d78c5a1853479357a69f4b5f813a2f9075ba
      # Status: needed with nixpkgs f205b5574fd0, last checked 2026-07-27.
      # Remove when: nixpkgs orders unix-early before fprintd in the default
      # auth rules.
      security.pam.services.login.rules.auth =
        lib.mkIf config.security.pam.services.login.useDefaultRules
          (
            let
              fprintdOrder = config.security.pam.services.login.rules.auth.fprintd.order;
            in
            {
              unix-early.order = fprintdOrder - 20;
              gnome_keyring.order = fprintdOrder - 10;
            }
          );

      # Noctalia's idle behaviors only fire on idle timeouts; also lock when sleep
      # is triggered directly (lid close, systemctl suspend, hibernate). Runs in
      # the pre-sleep phase of NixOS' built-in sleep-actions.service.
      powerManagement.powerDownCommands = "${lib.getExe' pkgs.systemd "loginctl"} lock-sessions";
    };
}
