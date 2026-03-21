# Nixarr autobrr ExecStartPre uses dasel v2 syntax incompatible with dasel v3
# Issue: https://github.com/rasmus-kirk/nixarr/issues (no upstream issue yet)
# Upstream PR: None yet
# Workaround: Override ExecStartPre to use sed instead of dasel for injecting sessionSecret into config.toml
# Status: temporary - nixarr upstream needs to update their dasel usage for v3 compatibility
# Last checked: 2026-03-21
# Remove after: nixarr updates autobrr module to use dasel v3 syntax or removes dasel dependency
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.nixarr.autobrr;
  configFormat = pkgs.formats.toml { };
  configTemplate = configFormat.generate "autobrr.toml" config.services.autobrr.settings;
in
{
  warnings = lib.optional cfg.enable "Workaround active: nixarr autobrr dasel v3 fix (nixos/_mixins/fixes/nixarr-autobrr-dasel-v3.nix). Check if nixarr upstream has fixed dasel v3 compatibility.";

  systemd.services.autobrr = lib.mkIf cfg.enable {
    serviceConfig.ExecStartPre = lib.mkOverride 49 (
      pkgs.writeShellScript "autobrr-config-prep" ''
        # Generate session secret if it doesn't exist
        SESSION_SECRET_FILE="${cfg.stateDir}/session-secret"
        if [ ! -f "$SESSION_SECRET_FILE" ]; then
          ${lib.getExe' pkgs.openssl "openssl"} rand -base64 32 > "$SESSION_SECRET_FILE"
          chmod 600 "$SESSION_SECRET_FILE"
        fi

        # Create config with session secret
        SESSION_SECRET=$(cat "$SESSION_SECRET_FILE")
        cp '${configTemplate}' "${cfg.stateDir}/config.toml"
        chmod 600 "${cfg.stateDir}/config.toml"

        # Inject sessionSecret into the TOML config using sed instead of dasel
        # Escape any special characters in the secret for sed
        ESCAPED_SECRET=$(printf '%s\n' "$SESSION_SECRET" | ${pkgs.gnused}/bin/sed 's/[&/\]/\\&/g')
        if ${pkgs.gnugrep}/bin/grep -q '^sessionSecret' "${cfg.stateDir}/config.toml"; then
          ${pkgs.gnused}/bin/sed -i "s|^sessionSecret.*|sessionSecret = \"$ESCAPED_SECRET\"|" "${cfg.stateDir}/config.toml"
        else
          echo "sessionSecret = \"$ESCAPED_SECRET\"" >> "${cfg.stateDir}/config.toml"
        fi
      ''
    );
  };
}
