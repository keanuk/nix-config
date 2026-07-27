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
        inputs.noctalia.nixosModules.default
        inputs.noctalia-greeter.nixosModules.default
      ];

      programs.noctalia = {
        enable = true;
        recommendedServices.enable = true;
      };

      # greetd-based greeter; no display manager needed alongside it.
      programs.noctalia-greeter.enable = true;

      # Unlock the GNOME keyring with the password entered at the greeter.
      # Requires the keyring password to match the login password.
      security.pam.services.greetd = {
        enableGnomeKeyring = true;
        # pam_fprintd is 'sufficient', so on fingerprint success all later auth
        # rules are skipped. Move the password prompt (unix-early, which sets
        # PAM_AUTHTOK) and the keyring capture before it, otherwise a
        # fingerprint login leaves the keyring locked.
        # Only applies when greetd uses nixpkgs' default PAM rules: current
        # nixpkgs sets useDefaultRules = false and substacks the `login`
        # service instead, which has no fprintd rule in greetd's own stack.
        rules.auth = lib.mkIf config.security.pam.services.greetd.useDefaultRules (
          let
            fprintdOrder = config.security.pam.services.greetd.rules.auth.fprintd.order;
          in
          {
            unix-early.order = fprintdOrder - 20;
            gnome_keyring.order = fprintdOrder - 10;
          }
        );
      };

      # Noctalia's idle behaviors only fire on idle timeouts; also lock when sleep
      # is triggered directly (lid close, systemctl suspend, hibernate). Runs in
      # the pre-sleep phase of NixOS' built-in sleep-actions.service.
      powerManagement.powerDownCommands = "${lib.getExe' pkgs.systemd "loginctl"} lock-sessions";
    };
}
