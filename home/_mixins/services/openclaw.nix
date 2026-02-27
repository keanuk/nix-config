# OpenClaw AI assistant gateway configuration
#
# This mixin configures nix-openclaw with Telegram + Mistral AI.
# Each host must pass the secret file paths via module arguments.
#
# Secret paths come from sops-nix on both platforms:
#   - NixOS (beehive): NixOS sops module → /run/secrets/
#   - macOS (salacia): Home Manager sops module → ~/.config/sops-nix/secrets/
{
  inputs,
  openclawTelegramTokenFile,
  openclawMistralApiKeyFile,
  openclawGatewayTokenFile,
  ...
}:
{
  imports = [
    inputs.nix-openclaw.homeManagerModules.openclaw
  ];

  programs.openclaw = {
    enable = true;

    # Use an explicit instance to avoid nix-openclaw's defaultInstance bug
    # (missing appDefaults.nixMode when not going through module system).
    instances.default = {
      config = {
        gateway = {
          mode = "local";
          auth = {
            # Placeholder — overridden at runtime by OPENCLAW_GATEWAY_TOKEN
            # env var loaded from secrets.env
            token = "nix-managed-use-env-var";
          };
        };

        channels.telegram = {
          tokenFile = openclawTelegramTokenFile;
          allowFrom = [ 15634717 ];
          groups = {
            "*" = {
              requireMention = true;
            };
          };
        };
      };
    };
  };

  # Write a secrets.env file that injects secrets into the gateway's
  # environment at runtime. The gateway reads OPENCLAW_GATEWAY_TOKEN and
  # MISTRAL_API_KEY from its process environment.
  home.activation.openclawSecrets = {
    after = [ "writeBoundary" ];
    before = [ ];
    data = ''
      OPENCLAW_ENV_DIR="$HOME/.config/openclaw"
      run mkdir -p "$OPENCLAW_ENV_DIR"
      run bash -c '
        GW_TOKEN=""
        MISTRAL_KEY=""
        if [ -f "${openclawGatewayTokenFile}" ]; then
          GW_TOKEN="$(cat "${openclawGatewayTokenFile}")"
        fi
        if [ -f "${openclawMistralApiKeyFile}" ]; then
          MISTRAL_KEY="$(cat "${openclawMistralApiKeyFile}")"
        fi
        printf "OPENCLAW_GATEWAY_TOKEN=%s\nMISTRAL_API_KEY=%s\n" "$GW_TOKEN" "$MISTRAL_KEY" \
          > "'"$OPENCLAW_ENV_DIR"'/secrets.env"
        chmod 600 "'"$OPENCLAW_ENV_DIR"'/secrets.env"
      '
    '';
  };
}
