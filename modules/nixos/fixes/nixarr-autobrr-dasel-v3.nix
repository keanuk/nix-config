{
  flake.modules.nixos.nixarr-autobrr-dasel-v3 =
    {
      config,
      lib,
      pkgs,
      options,
      ...
    }:
    let
      hasNixarr = options ? nixarr;
      cfg = config.nixarr.autobrr;
      configFormat = pkgs.formats.toml { };
      configTemplate = configFormat.generate "autobrr.toml" config.services.autobrr.settings;
    in
    {
      config = lib.mkIf (hasNixarr && cfg.enable) {
        warnings = [
          "Workaround active: nixarr autobrr dasel v3 fix. Check if nixarr upstream has fixed dasel v3 compatibility."
        ];

        systemd.services.autobrr = {
          serviceConfig.ExecStartPre = lib.mkOverride 49 (
            pkgs.writeShellScript "autobrr-config-prep" ''
              SESSION_SECRET_FILE="${cfg.stateDir}/session-secret"
              if [ ! -f "$SESSION_SECRET_FILE" ]; then
                ${lib.getExe' pkgs.openssl "openssl"} rand -base64 32 > "$SESSION_SECRET_FILE"
                chmod 600 "$SESSION_SECRET_FILE"
              fi

              SESSION_SECRET=$(cat "$SESSION_SECRET_FILE")
              cp '${configTemplate}' "${cfg.stateDir}/config.toml"
              chmod 600 "${cfg.stateDir}/config.toml"

              ESCAPED_SECRET=$(printf '%s\n' "$SESSION_SECRET" | ${pkgs.gnused}/bin/sed 's/[&/\]/\\&/g')
              if ${pkgs.gnugrep}/bin/grep -q '^sessionSecret' "${cfg.stateDir}/config.toml"; then
                ${pkgs.gnused}/bin/sed -i "s|^sessionSecret.*|sessionSecret = \"$ESCAPED_SECRET\"|" "${cfg.stateDir}/config.toml"
              else
                echo "sessionSecret = \"$ESCAPED_SECRET\"" >> "${cfg.stateDir}/config.toml"
              fi
            ''
          );
        };
      };
    };
}
