# OpenClaw AI assistant gateway configuration
#
# This mixin configures nix-openclaw with Telegram + Mistral AI.
# Each host must pass the secret file paths via module arguments.
#
# Secret paths come from sops-nix on both platforms:
#   - NixOS (beehive): NixOS sops module → /run/secrets/
#   - macOS (salacia): Home Manager sops module → ~/.config/sops-nix/secrets/
#
# Usage in host config:
#   (import ../_mixins/services/openclaw.nix {
#     inherit inputs;
#     openclawTelegramTokenFile = "/run/secrets/...";
#     openclawMistralApiKeyFile = "/run/secrets/...";
#     openclawGatewayTokenFile  = "/run/secrets/...";
#   })
{
  inputs,
  openclawTelegramTokenFile,
  openclawMistralApiKeyFile,
  openclawGatewayTokenFile,
  pkgs,
  ...
}:
let
  openclawDocuments = ./openclaw-documents;
  openclawAuthProfiles = builtins.toJSON {
    version = 1;
    profiles = {
      "mistral:default" = {
        type = "api_key";
        provider = "mistral";
        keyRef = {
          source = "file";
          provider = "mistral";
          id = "value";
        };
      };
    };
  };
in
{
  imports = [
    inputs.nix-openclaw.homeManagerModules.openclaw
  ];

  programs.openclaw = {
    enable = true;
    documents = openclawDocuments;

    bundledPlugins = {
      summarize.enable = true;
      peekaboo.enable = pkgs.stdenv.hostPlatform.isDarwin;
      poltergeist.enable = pkgs.stdenv.hostPlatform.isDarwin;
      goplaces.enable = false;
      bird.enable = false;
      imsg.enable = false;
    };

    # The steipete/bird GitHub repo and its releases have been deleted,
    # so the bird package fails to fetch. Exclude it until upstream fixes this.
    # Also exclude tools that conflict with individually installed packages
    # (python3, idle, node, go, rg, ffmpeg, curl, jq, etc.) to avoid
    # buildEnv collisions in home-manager-path.
    excludeTools = [
      "bird"
      "curl"
      "ffmpeg"
      "go"
      "jq"
      "nodejs_22"
      "pnpm_10"
      "python3"
      "ripgrep"
    ];

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

        agents = {
          defaults = {
            model = {
              primary = "mistral/mistral-large-latest";
              fallbacks = [
                "mistral/mistral-medium-latest"
                "mistral/mistral-small-latest"
              ];
            };
          };
        };

        secrets = {
          providers = {
            mistral = {
              source = "file";
              path = openclawMistralApiKeyFile;
              mode = "singleValue";
            };
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

  home.file.".openclaw/agents/main/agent/auth-profiles.json" = {
    text = openclawAuthProfiles;
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
