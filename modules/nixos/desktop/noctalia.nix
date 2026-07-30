{ inputs, ... }:
{
  flake.modules.nixos.noctalia =
    {
      pkgs,
      lib,
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

      # Require a password at the greeter and unlock the GNOME keyring with
      # it (set up by nixpkgs' greetd module via enableGnomeKeyring). nixpkgs'
      # greetd PAM module hard-codes `useDefaultRules = false` and sets
      # rules.{auth,account,password,session} to `login` substack/include
      # entries, so the greeter authenticates through the `login` service.
      # `login` carries `pam_fprintd` as 'sufficient' ahead of `pam_unix`: a
      # successful fingerprint scan at the greeter skips the password, so
      # PAM_AUTHTOK is never set and pam_gnome_keyring's auto_start has no
      # password to unlock the keyring. Worse, the no-arg gnome_keyring auth
      # rule stashes the rejected-from-pam_unix token regardless, and
      # auto_start then uses it to *re-key* the keyring master on the next
      # successful (fingerprint-carried) login — silently overwriting it
      # with a typo.
      #
      # Put greetd on its own default PAM stack (mkForce true overrides the
      # substack), disable the leftover `login` substack/include rules so
      # they don't collide with the regenerated defaults (nixpkgs' order
      # check only considers enabled rules; see pam.nix ~line 928), turn
      # fprintd OFF on the greeter, and auto-unlock the keyring. The greeter
      # is then password-only, so a typo can't be masked by fingerprint.
      #
      # Noctalia's lockscreen authenticates against the `login` PAM service
      # (per https://docs.noctalia.dev/v5/getting-started/faq), not `greetd`,
      # so it keeps fprintd and the fingerprint-unlock feature. Reboot /
      # initial login is now password-only; lockscreen keeps fingerprint.
      # Ref: nixpkgs f205b5574fd0 (nixos/modules/services/display-managers/greetd.nix)
      # Status: needed with nixpkgs f205b5574fd0, last checked 2026-07-30.
      # Remove when: nixpkgs greetd module stops substacking `login` for auth,
      # or ships a built-in to disable fprintd only for the greeter.
      security.pam.services.greetd = {
        useDefaultRules = lib.mkForce true;
        enableGnomeKeyring = true;
        rules = {
          auth.fprintd.enable = lib.mkForce false;
          auth.login.enable = lib.mkForce false;
          account.login.enable = lib.mkForce false;
          password.login.enable = lib.mkForce false;
          session.login.enable = lib.mkForce false;
        };
      };

      # Noctalia's idle behaviors only fire on idle timeouts; also lock when sleep
      # is triggered directly (lid close, systemctl suspend, hibernate). Runs in
      # the pre-sleep phase of NixOS' built-in sleep-actions.service.
      powerManagement.powerDownCommands = "${lib.getExe' pkgs.systemd "loginctl"} lock-sessions";
    };
}
